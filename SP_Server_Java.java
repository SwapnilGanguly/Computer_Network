import java.io.*;
import java.net.*;
import java.time.LocalDateTime;

public class Server {
    public static void main(String[] args) {
        try (ServerSocket serverSocket = new ServerSocket(5000)) {
            System.out.println("Server is running...");
            Socket socket = serverSocket.accept();
            System.out.println("Client connected!");

            PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
            LocalDateTime dateTime = LocalDateTime.now();
            out.println("Hi, I am Shouvik. Current Date and Time: " + dateTime);

            socket.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
