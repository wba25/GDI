package br.com.g7gdi.projeto.API;

/**
 * Created by wellington on 18/06/17.
 */
import java.sql.*;
// Test
public class JDBCtest {
    // JDBC driver name and database URL
    static final String JDBC_DRIVER = "oracle.jdbc.OracleDriver";
    static final String DB_URL = "jdbc:oracle:thin:@localhost:1521:global_database_name";

    //  Database credentials
    static final String USER = "wba";
    static final String PASS = "cebola15";

    public static void main(String[] args) {
        Connection conn = null;
        Statement stmt = null;
        System.out.print("Teste");
        try{
            //Register JDBC driver
            Class.forName("oracle.jdbc.driver.OracleDriver");

            //Open a connection
            System.out.println("Connecting to database...");
            conn = DriverManager.getConnection(DB_URL,USER,PASS);

            //Execute a query
            System.out.println("Creating statement...");
            stmt = conn.createStatement();
            String sql;
            sql = "SELECT nome FROM tb_paciente";
            ResultSet rs = stmt.executeQuery(sql);

            //Extract data from result set
            while(rs.next()){
                //Retrieve by column name
                String nome = rs.getString("nome");

                //Display values
                System.out.print("Nome: " + nome);
            }
            //Clean-up environment
            rs.close();
            stmt.close();
            conn.close();
        }catch(SQLException se){
            //Handle errors for JDBC
            se.printStackTrace();
        }catch(Exception e){
            //Handle errors for Class.forName
            e.printStackTrace();
        }finally{
            //finally block used to close resources
            try{
                if(stmt!=null)
                    stmt.close();
            }catch(SQLException se2){
            }// nothing we can do
            try{
                if(conn!=null)
                    conn.close();
            }catch(SQLException se){
                se.printStackTrace();
            }//end finally try
        }//end try
        System.out.println("Goodbye!");
    }//end main
}//end FirstExample
