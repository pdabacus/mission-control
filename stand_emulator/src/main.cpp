/**
 * @file src/main.cpp
 * @author Pavan Dayal
 */

#include <iostream>
#include <cstdio>
#include <cstring>
#include <string>

void help();
void version();
void show_help();
void show_info();

static int port = DEFAULT_PORT;

int main(int argc, char* argv[]) {
    int j;
    bool v = false;
    bool h = false;

    // check for args
    for (j=1; j<argc; ++j) {
        if (0 == strcmp(argv[j], "-v")) {
            v= true;
        } else if (0 == strcmp(argv[j], "--v")) {
            v= true;
        } else if (0 == strcmp(argv[j], "-h")) {
            h= true;
        } else if (0 == strcmp(argv[j], "--h")) {
            h= true;
        } else {
            fprintf(stderr, "error: unrecognized option '%s'\n", argv[j]);
            return EXIT_FAILURE;
        }
    }

    if (h) {
        help();
        return EXIT_SUCCESS;
    }

    if (v) {
        version();
        return EXIT_SUCCESS;
    }

    // start emulator main loop
    std::string cmd;
    size_t n;
    while (true) {
        printf("stand_emulator >> ");
        fflush(stdout);
        std::getline(std::cin, cmd);
        n = cmd.find_first_not_of(" \n\r\t\f\v");

        if (std::cin.eof()) {
            printf("\n");
            break;
        } else if (cmd.find("exit", n) != std::string::npos) {
            break;
        } else if (cmd.find("quit", n) != std::string::npos) {
            break;
        } else if (cmd.find("help", n) != std::string::npos) {
            show_help();
        } else if (cmd.find("info", n) != std::string::npos) {
            show_info();
        }
    }

    return EXIT_SUCCESS;
}

void help() {
    printf("stand_emu [-h -v]\n");
    printf("   -h --help        show this help screen\n");
    printf("   -v --version     show version\n");
}

void version() {
    printf("stand_emu %s\n", VERSION);
}

void show_help() {
    printf("help:\n");
    printf("    help            show this help screen\n");
    printf("    info            show information about the emulator\n");
    printf("    exit            stop the emulator\n");
}

void show_info() {
    printf("info:\n");
    printf("    port            %d\n", port);
}
