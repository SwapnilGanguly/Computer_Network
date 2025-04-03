#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <time.h>

int main() {
    int server_fd, client_fd;
    struct sockaddr_in server_addr, client_addr;
    socklen_t addr_len = sizeof(client_addr);
    char buffer[1024];

    server_fd = socket(AF_INET, SOCK_STREAM, 0);
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(5000);

    bind(server_fd, (struct sockaddr*)&server_addr, sizeof(server_addr));
    listen(server_fd, 5);

    printf("Server is running...\n");
    client_fd = accept(server_fd, (struct sockaddr*)&client_addr, &addr_len);
    printf("Client connected!\n");

    time_t t;
    time(&t);
    snprintf(buffer, sizeof(buffer), "Hi, I am Shouvik. Current Date and Time: %s", ctime(&t));
    send(client_fd, buffer, strlen(buffer), 0);

    close(client_fd);
    close(server_fd);
    return 0;
}
