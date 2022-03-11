#! /bin/bash

HELP_Command()      # Displays Help
{
    echo "Usage: Internsctl Command Help"
    echo
    echo "Syntax: internsctl [COMMAND] [OPTION]"
    echo "options:"
    echo "cpu        Defines cpu related commands"
    echo "memory     Defines memory related commands"
    echo "user       Defines user related commands"
    echo "file       Defines file related commands"
    echo "help       Displays this help message"
    echo "version    Displays the version of the script"
    echo "Type 'internsctl [command] --help' for more information on a command"
}

args=("$@")
check_stat(){
    if [[ -f "${args[3]}" ]] ;then
    files=("${args[@]:3}")
    for item in "${files[@]}"; do
        if [[ -f $item ]]; then 
            case ${1} in
                "s")
                    size=$(stat -c%"${1}" "${item}")
                    echo "${item} : ${size} bytes"
                    ;;
                "U")
                    user=$(stat -c%"${1}" "${item}")
                    echo "${item} : (${user}) User"
                    ;;
                "A")
                    perm=$(stat -c%"${1}" "${item}")
                    echo "${item} : (${perm}) Access"
                    ;;
                "y")
                    time=$(stat -c%"${1}" "${item}")
                    echo "${item} : ${time}"
                    ;;
            esac
        else
            echo "Invalid file: ${item}">&2
            exit 1;
        fi
    done
    else
        echo "Put the file name after the command to check the file status">&2
    fi
}

if [ $# -eq 0 ]; then
    HELP_Command
    exit 0;
else
    case ${args[0]} in
        -v | --version)
            echo "internsctl: v0.1.0";;
        -h | --help)
            HELP_Command
            exit;;
        cpu)
            case ${args[1]} in
                getinfo)
                lscpu
                exit;;

                -h | --help)
                echo "Syntax: internsctl cpu getinfo"
                echo -e "\e[3mgetinfo\e[0m: Display information about the CPU."
                exit;;

                *)
                echo "Invalid option: '${args[1]}'. Try 'internsctl cpu --help[-h]' for more information.">&2
                exit 1;;
            esac;;
        memory)
            case ${args[1]} in
                getinfo)
                free
                exit;;

                -h | --help)
                echo "Syntax: internsctl memory getinfo"
                echo -e "\e[3mgetinfo\e[0m: Display information about the memory."
                exit;;

                *)
                echo "Invalid option: '${args[1]}'. Try 'internsctl memory --help[-h]' for more information.">&2
                exit 1;;
            esac;;

        user)
            case ${args[1]} in
                create)
                if [[ -n "${args[2]}" ]]; then      # Checks if the string is not empty
                    sudo adduser "${args[2]}";
                    echo "User ${args[2]} created successfully."
                    exit;
                else
                    echo "No user specified."
                fi;;

                list)
                case ${args[2]} in
                    --sudo-only)
                    grep '^sudo:.*$' /etc/group | cut -d: -f4 | sort -u
                    exit;;
                    "")
                    awk -F: '{ print $1}' /etc/passwd | sort -u | less
                    exit;;
                    *)
                    echo "Invalid option: '${args[2]}'. Try 'internsctl user --help[-h]' for more information.">&2
                    exit 1;; 
                esac;;
                
                -h | --help)
                echo "Syntax: internsctl user [OPTION] [USERNAME](optional)"
                echo -e "\e[3mcreate [USERNAME]\e[0m: Create a new user. Sudo permission is needed."
                echo -e "\e[3mlist\e[0m: List all users."
                echo -e "\e[3mlist --sudo-only\e[0m: List all users with sudo access."
                exit;;
                *)
                echo "Invalid option: '${args[1]}'. Try 'internsctl user --help[-h]' for more information.">&2
                exit 1;;
            esac;;
        file)
            case ${args[1]} in
                getinfo)
                        if [[ -f "${args[2]}" ]] ;then
                            files=("${args[@]:2}")
                            for item in "${files[@]}"; do
                            if [[ -f $item ]]; then         # Checks if the file exists
                                stat "${item}";
                            else
                                echo "Invalid file: ${item}";
                            fi
                            done
                        else
                            case ${args[2]} in
                                -s | --size)
                                    check_stat "s";
                                    exit;;
                                -o| --owner)
                                    check_stat "U";
                                    exit;;
                                -p | --permissions)
                                    check_stat "A";
                                    exit;;
                                -m| --last-modified)
                                    check_stat "y";
                                    exit;;
                                -h| --help)
                                    echo "Syntax: internsctl file getinfo [OPTION] [FILE]..."
                                    echo -e "\e[3mgetinfo [OPTION] [FILES]\e[0m: Displays specific information about the file."
                                    echo -e "\e[3m-s, --size\e[0m: Displays the size of the file."
                                    echo -e "\e[3m-o, --owner\e[0m: Displays the owner of the file."
                                    echo -e "\e[3m-p, --permissions\e[0m: Displays the permissions of the file."
                                    echo -e "\e[3m-m, --last-modified\e[0m: Displays the last modified time of the file."

                                    exit;;
                                *)
                                echo "Invalid option: '${args[2]}'. Try 'internsctl file getinfo --help[-h]' for more information.">&2
                                exit 1;;
                            esac
                            fi;;
            -h | --help)
            echo "Syntax: internsctl file getinfo [OPTION](optional) [FILE]..."
            echo -e "\e[3mgetinfo [FILES]\e[0m: Display all information about the files."
            echo -e "\e[3mgetinfo [OPTION] [FILES]\e[0m: Display specific information about the files."
            echo "Type 'internsctl file getinfo --help[-h]' to see all options."
            exit;;

            *)
                echo "Invalid option: '${args[1]}'. Try 'internsctl file --help[-h]' for more information.">&2
                exit 1;;
            esac;;
        *)
        echo "Error: Invalid option"
        echo "Try 'internsctl --help[-h]' for more information.">&2
        exit 1;;
    esac
fi
