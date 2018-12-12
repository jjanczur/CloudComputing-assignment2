//
// Created by imolcean on 10.12.18.
//

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <stdlib.h>
#include <sys/wait.h>

#define IN 0
#define OUT 1

// When not set to 0, debug output will be on.
int DEBUG;

/**
 * Prints debug information to stderr, if DEBUG is not set to 0.
 *
 * @param str String to print
 */
void debug(char* str)
{
    if(DEBUG)
    {
        fprintf(stderr, "[DEBUG] %s \n", str);
    }
}

/**
 * Reads an integer value from the given pipe.
 *
 * If reading is not possible, the process will be ended with an error.
 *
 * @param fd Descriptor of the pipe's input
 * @return Integer read from the pipe
 */
int readInt(int fd)
{
    ssize_t cnt;
    char buf[64];

    memset(buf, 0, sizeof(buf));

    while((cnt = read(fd, buf, sizeof(buf))) < 0 && (errno == EINTR)) {}

    if(cnt < 0)
    {
        perror("Read");
        exit(-1);
    }

    if(cnt == 0)
    {
        perror("EOF");
        exit(-1);
    }

    return atoi(buf);
}

/**
 * Sums all integers from min to max using the recursive forksum algorithm.
 *
 * If min = max, their value will be returned. Otherwise, two processes will be created,
 * to calculate the result recursively for both halves of the interval.
 *
 * @param min Left boundary of the interval
 * @param max Right boundary of the interval
 * @return Sum of all integers in the interval
 */
int sum(int min, int max)
{
    // Recursion anchor

    if(min == max)
    {
        return min;
    }


    int mid = (min + max) / 2;


    // Create pipes to get results from children

    int fdl[2];
    int fdr[2];

    while(pipe(fdl) < 0 && errno == ENFILE)
    {
        // System limit on open files reached, wait until something is closed

        debug("Pipe left failed (will retry)");
    }

    while(pipe(fdr) < 0 && errno == ENFILE)
    {
        // System limit on open files reached, wait until something is closed

        debug("Pipe right failed (will retry)");
    }

    if(pipe(fdl) < 0 || pipe(fdr) < 0)
    {
        // Creation of a pipe failed due to another reason

        perror("Pipe");
        return -1;
    }


    // Create two child processes, let them calculate the results for two parts recursively and sum their results.

    pid_t pidl;
    pid_t pidr;

    while((pidl = fork()) < 0 && errno == EAGAIN)
    {
        // Not enough resources

        debug("Fork left failed (will retry)");
    }

    if(pidl < 0)
    {
        // Fork failed due to another reason

        perror("Fork left failed");
        return -1;
    }
    else if(pidl > 0)
    {
        while((pidr = fork()) < 0 && errno == EAGAIN)
        {
            // Not enough resources

            debug("Fork right failed (will retry)");
        }

        if(pidr < 0)
        {
            // Fork failed due to another reason

            perror("Fork right failed");
            return -1;
        }
        else if(pidr > 0)
        {
            // PARENT


            // Close output of the pipes

            close(fdl[OUT]);
            close(fdr[OUT]);


            // Wait for the child processes to terminate

            int statusl;
            int statusr;

            waitpid(pidl, &statusl, 0);
            waitpid(pidr, &statusr, 0);


            // Read the results of the child processes from the pipes

            int result = readInt(fdl[IN]) + readInt(fdr[IN]);


            // Close the rest of file descriptors before returning

            close(fdl[IN]);
            close(fdr[IN]);


            return result;
        }
        else
        {
            // CHILD RIGHT

            debug("Fork right SUCCEEDED");


            // Close the unneeded descriptors

            close(fdl[IN]);
            close(fdl[OUT]);

            close(fdr[IN]);


            // Redirect stdout to the pipe

            while((dup2(fdr[OUT], STDOUT_FILENO)) && (errno == EINTR)) {}
            close(fdr[OUT]);


            // Recursively calculate the result for the right part

            return sum(mid + 1, max);
        }
    }
    else
    {
        // CHILD LEFT

        debug("Fork left SUCCEEDED");


        // Close the unneeded descriptors

        close(fdr[IN]);
        close(fdr[OUT]);

        close(fdl[IN]);


        // Redirect stdout to the pipe

        while((dup2(fdl[OUT], STDOUT_FILENO)) && (errno == EINTR)) {}
        close(fdl[OUT]);


        // Recursively calculate the result for the left part

        return sum(min, mid);
    }
}

int main(int argc, char** argv)
{
    if(argc < 3)
    {
        printf("Arguments needed: min max [debug] \n");
        return -1;
    }

    if(argc >= 4)
    {
        DEBUG = 1;
    }
    else
    {
        DEBUG = 0;
    }

    int min = atoi(argv[1]);
    int max = atoi(argv[2]);

    printf("%d", sum(min, max));

    return 0;
}
