import java.io.*;
import java.net.*;

class Client{
	public static void main(String args[]){
		try(Socket socket = new Socket("localhost", 5000)){
			BufferedReader br = new BufferedReader(new InputStreamReader(socket.getInputStream()));
			String message = br.readLine();
			System.out.println("Server says: "+message);
			
		}
		catch(Exception e){}
	}
}