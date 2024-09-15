#!/bin/bash

# Make log of update
# Define the directory where logs will be stored
LOG_DIR="$HOME/documents/nixos-update-logs"

# Create the log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Generate a log file name based on the current date and time
LOG_FILE="$LOG_DIR/$(date +"%Y-%m-%d_%H-%M-%S").log"

# Make log of the update and store it in the log file
exec > >(tee "$LOG_FILE") 2>&1

log_action "Running NixOS Update Script - $(date +"%Y-%m-%d %H:%M:%S")"# Log status message
log() {
    echo -e "\e[32m[INFO]\e[0m $1"
}

# Log prompt message
log_action() {
    echo -e "\e[34m[PROMPT]\e[0m $1"  # Blue color for prompts
}

# Log error message and exit
log_error() {
    echo -e "\e[31m[ERROR]\e[0m $1"
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
        log_action "Do you want to do a COMPLETE clean of old generatiions, performance gabage collection, and remove all orphaned packages? (YES/n) "
        read -r answer
        if [ "$answer" == "YES" ]; then
            log "Performing complete clean of all old generations and unused files..."
            sudo nix-collect-garbage -d || log_error "Failed to perform complete clean."
            sudo nix-store --gc || log_error "Failed to clean up unused dependencies."
            sudo nix-env --delete-generations || log_error "Failed to remove orphaned packages."
            log "Complete clean finished."
            log "***It's a good idea to rebuild the system after a complete clean to clear old boot entries and to make sure nothing went wrong!***"
            return 0
        else
            log "Skipping complete clean."
            return 1
        fi
    done
}

# Ask the user if they want to do a dry run
ask_dry_run() {
    while true; do
        log_action "Do you want to perform a dry run first? (y/n) "
        read -r answer
        case $answer in
            [Yy]* )
                log "Running dry run..."
                
                sleep 1  # Add a small delay to avoid missing initial output

                # Run the dry run command and print output directly to the terminal
                if review_flake_diff; then
                    log "Dry run completed successfully."
                else
                    log_error "Dry run failed with exit code $?."
                    return 1  # Exit the function and continue script flow
                fi
                return 0  # Gracefully exit function and continue the main script
                ;;
            [Nn]* )
                log "Skipping dry run."
                return 0  # Gracefully exit and continue to the next step in the script
                ;;
            * )
                log "Please answer y or n."
                ;;
        esac
    done
}

# Ask about cleaning up the system and removing orphaned packages
ask_cleanup() {
    while true; do
        log_action "Do you want to clean old generations, perform garbage collection, and remove orphaned packages? (y/n) "
        read -r answer
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
                log "Please answer y or n."
                ;;
        esac
    done
}

# Ask the user if they want to update the flake
ask_update_flake() {
    while true; do
        log_action "Do you want to update the flake? (y/n) "
        read -r answer
        case $answer in
            [Yy]* )
                sleep 1  # Add a small delay to avoid missing initial output

                # Run the update flake command and print output directly to the terminal
                update_flake

                log "Flake update completed."
                break
                ;;
            [Nn]* )
                log "Skipping flake update."
                break
                ;;
            * )
                log "Please answer y or n."
                ;;
        esac
    done
}

# Ask the user if they want to rebuild after a complete clean
ask_rebuild_after_clean() {
    while true; do
        log_action "Do you want to rebuild the system after the complete clean? (y/n) "
        read -r answer
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
                log "Please answer y or n."
                ;;
        esac
    done
}

# Change to the working directory
log "Running NixOS Update Script - $(date)"
cd /persist/etc/nixos/ || log_error "Failed to change directory to /persist/etc/nixos/"

# Run txr and lazygit
run_txr
run_lazygit

# Check disk space after lazygit is closed
check_disk_space

# Ask the user if they want to update the flake
ask_update_flake 

# Ask if the user wants a dry run first
ask_dry_run

# Ask the user if they want to run nixos-rebuild
while true; do
    log_action "Do you want to switch with nixos-rebuild? (y/n) "
    read -r answer
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
            log "Please answer y or n."
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

log "*** REMEMBER THIS SCRIPT IS SYMLINKED MANUALLY, ONCE YOU MOVE THE SYMLINK TO NIXOS CONFIG YOU CAN REMOVE THIS ***"
