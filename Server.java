import java.io.*;
import java.net.*;

public class Server{
	public static void main(String args[]){
		try(ServerSocket serverSocket = new ServerSocket(5000)){
			System.out.println("Server is running...");
			Socket socket = serverSocket.accept();
			System.out.println("Client is connected");
			
			PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
			out.println("My name is Swapnil.");
			
			socket.close();
		}
		catch(Exception e){}
	}
}