#!/bin/bash

# Exit on error
set -e

# Log status message
log() {
    echo -e "\e[32m[INFO]\e[0m $1"
}

# Log error message and exit
log_error() {
    echo -e "\e[31m[ERROR]\e[0m $1"
    exit 1
}

# Function to check if a command exists
check_command() {
    if ! command -v "$1" &>/dev/null; then
        log_error "$1 command not found."
    fi
}

# Function to run txr command
run_txr() {
    check_command "/home/crackz/.local/bin/txr"
    log "Running txr..."
    /home/crackz/.local/bin/txr || log_error "txr command failed."
}

# Function to run lazygit
run_lazygit() {
    check_command "lazygit"
    log "Running lazygit..."
    lazygit || log_error "lazygit command failed."
}

# Function to perform nixos-rebuild with flake
run_nixos_rebuild() {
    check_command "nixos-rebuild"
    log "Running nixos-rebuild..."
    sudo nixos-rebuild switch --flake .#nixbox || log_error "nixos-rebuild failed."
}

# Function to dry run nixos-rebuild with flake
review_flake_diff() {
    log "Performing flake-based dry run for nixos-rebuild..."
    sudo nixos-rebuild dry-run --flake .#nixbox || log_error "Failed to perform flake-based dry run."
}

# Function to clean old generations and garbage collection, including removing orphaned packages
cleanup_system() {
    log "Cleaning up old generations and running garbage collection..."
    sudo nix-collect-garbage --delete-older-than 30d || log_error "Failed to clean up old generations."
    sudo nix-store --gc || log_error "Failed to clean up orphaned dependencies."
    remove_orphaned_packages
}

# Function to remove orphaned packages
remove_orphaned_packages() {
    log "Removing orphaned packages..."
    sudo nix-env --delete-generations || log_error "Failed to remove orphaned packages."
}

# Function to update flake
update_flake() {
    log "Updating flake.lock..."
    nix flake update || log_error "Failed to update flake.lock."
}

# Function to check disk space and display available space
check_disk_space() {
    log "Checking disk space usage..."
    avail=$(df -h / | awk 'NR==2 {print $4}')
    log "Available disk space: $avail"
}

# Function to ask for a complete clean
complete_clean() {
    while true; do
        read -p "Do you want to do a COMPLETE clean of old generatiions, performance gabage collection, and remove all orphaned packages? (YES/n) " answer
        if [ "$answer" == "YES" ]; then
            log "Performing complete clean of all old generations and unused files..."
            sudo nix-collect-garbage -d || log_error "Failed to perform complete clean."
            sudo nix-store --gc || log_error "Failed to clean up unused dependencies."
            sudo nix-env --delete-generations || log_error "Failed to remove orphaned packages."
            log "Complete clean finished."
            log "***It's a good idea to rebuild the system after a complete clean to clear old boot entries and make sure you nothing went wrong!***"
            return 0
        else
            log "Skipping complete clean."
            return 1
        fi
    done
}

# Ask about dry run
ask_dry_run() {
    while true; do
        read -p "Do you want to perform a dry run first? (y/n) " answer
        case $answer in
            [Yy]* )
                temp_file=$(mktemp)  # Create a temporary file
                review_flake_diff > "$temp_file" 2>&1  # Redirect output to the temp file

                # Filter out lines containing "[INFO]", "building the system configuration...", "^M", and "~"
                awk '!/\[INFO\]/ && !/building the system configuration.../ && !/\r/ && !/^~$/ {print}' "$temp_file" > filtered_temp_file

                if [[ -s filtered_temp_file ]]; then  # Check if filtered temp file is not empty
                    less -R filtered_temp_file  # Use less to display if output exists
                else
                    echo "No relevant output from dry run."
                fi
                rm "$temp_file" filtered_temp_file  # Clean up temporary files
                break
                ;;
            [Nn]* )
                log "Skipping dry run."
                break
                ;;
            * )
                echo "Please answer y or n."
                ;;
        esac
    done
}

# Ask about cleaning up the system and removing orphaned packages
ask_cleanup() {
    while true; do
        read -p "Do you want to clean old generations, perform garbage collection, and remove orphaned packages? (y/n) " answer
        case $answer in
            [Yy]* )
                cleanup_system
                break
                ;;
            [Nn]* )
                log "Skipping cleanup."
                break
                ;;
            * )
                echo "Please answer y or n."
                ;;
        esac
    done
}

# Ask about updating the flake
ask_update_flake() {
    while true; do
        read -p "Do you want to update the flake before rebuilding? (y/n) " answer
        case $answer in
            [Yy]* )
                temp_file=$(mktemp)  # Create a temporary file
                update_flake > "$temp_file" 2>&1  # Redirect the flake update output to the temp file

                # Optionally filter out unwanted [INFO] lines
                awk '!/\[INFO\]/ {print}' "$temp_file" > filtered_temp_file

                if [[ -s filtered_temp_file ]]; then  # Check if filtered temp file is not empty
                    less -R filtered_temp_file  # Use less to display the output
                else
                    echo "No relevant output from flake update."
                fi

                rm "$temp_file" filtered_temp_file  # Clean up temporary files
                break
                ;;
            [Nn]* )
                log "Skipping flake update."
                break
                ;;
            * )
                echo "Please answer y or n."
                ;;
        esac
    done
}

# Ask the user if they want to rebuild after a complete clean
ask_rebuild_after_clean() {
    while true; do
        read -p "Do you want to rebuild the system after the complete clean? (y/n) " answer
        case $answer in
            [Yy]* )
                run_nixos_rebuild
                break
                ;;
            [Nn]* )
                log "Skipping rebuild."
                break
                ;;
            * )
                echo "Please answer y or n."
                ;;
        esac
    done
}

# Change to the working directory
log "Changing to /persist/etc/nixos/..."
cd /persist/etc/nixos/ || log_error "Failed to change directory to /persist/etc/nixos/"

# Ask the user if they want to update the flake
ask_update_flake 

# Run txr and lazygit
run_txr
run_lazygit

# Check disk space after lazygit is closed
check_disk_space

# Ask if the user wants a dry run first
ask_dry_run

# Ask the user if they want to run nixos-rebuild
while true; do
    read -p "Do you want to switch with nixos-rebuild? (y/n) " answer
    case $answer in
        [Yy]* )
            run_nixos_rebuild
            break
            ;;
        [Nn]* )
            log "Skipping nixos-rebuild."
            break
            ;;
        * )
            echo "Please answer y or n."
            ;;
    esac
done

# Ask if the user wants to clean up the system and remove orphaned packages
ask_cleanup

# Ask if the user wants to perform a complete clean
if complete_clean; then
    # If the user did the complete clean, ask if they want to rebuild the system
    ask_rebuild_after_clean
fi

echo "*** REMEMBER THIS SCRIPT IS SYMLINKED MANUALLY, ONCE YOU MOVE THE SYMLINK TO NIXOS CONFIG YOU CAN REMOVE THIS ***"
