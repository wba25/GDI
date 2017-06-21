package br.com.g7gdi.projeto.API;

/**
 * Created by wellington on 18/06/17.
 */
import java.io.InputStream;
import java.sql.*;
import java.util.ArrayList;
import java.util.Objects;

// Test
public class JDBC {
    // JDBC driver name and database URL
    static final String JDBC_DRIVER = "oracle.jdbc.OracleDriver";
    static final String DB_URL = "jdbc:oracle:thin:@localhost:1521/xe";
    //connect username/password@connect_identifier

    //  Database credentials
    static final String USER = "wba";
    static final String PASS = "cebola15";

    private Connection connection;
    private Statement statement;
    private PreparedStatement pstmt;

    public JDBC() {
        this.connection = null;
        this.statement = null;
        this.pstmt = null;
        //pstmt.setBinaryS  tream();
    }

    public ArrayList<Object> selectRecepcionista(){
        ArrayList<Object> result = new ArrayList<>();
        try{
            start();
            //Execute a query
            System.out.println("Creating statement...");

            statement = connection.createStatement( );

            String sql;
            sql = "SELECT id, nome, foto FROM tb_recepcionista";
            ResultSet rs = statement.executeQuery(sql);
            //System.out.println(rs.wasNull());
            //Extract data from result set
            while(rs.next()){
                //Retrieve by column name
                String nome = rs.getString("nome");
                String id = rs.getString("id");
                String foto = rs.getString("foto");
                result.add(id);
                result.add(nome);
                result.add(foto);
            }
            rs.close();
            statement.close();
            connection.close();
        }catch(SQLException se){
            //Handle errors for JDBC
            se.printStackTrace();
        }catch(Exception e){
            //Handle errors for Class.forName
            e.printStackTrace();
        }finally{
            //finally block used to close resources
            try{
                if(statement !=null)
                    statement.close();
            }catch(SQLException se2){
            }// nothing we can do
            try{
                if(connection !=null)
                    connection.close();
            }catch(SQLException se){
                se.printStackTrace();
            }//end finally try
        }
        return result;
    }

    public boolean insertRecepcionista(String id, String nome, String telefone, String cep, String bairro, String numero, String cidade, String rua, String estado, String img) {
        try{
            start();
            //Execute a query
            System.out.println("Creating statement...");

            statement = connection.createStatement( );

            String sql;
            //sql = "INSERT INTO tb_recepcionista VALUES (tp_recepcionista("+id+",'"+nome+"', tp_fones(tp_fone('"+telefone+"')), tp_endereco("+cep+",'"+rua+"','"+numero+"','"+bairro+"','"+cidade+"','"+estado+"'),?))";
            sql = "INSERT INTO tb_recepcionista VALUES (tp_recepcionista(?,?, tp_fones(tp_fone(?)), tp_endereco(?,?,?,?,?,?), ?))";
            System.out.println(sql);
            pstmt = connection.prepareStatement(sql);
            pstmt.setString(1, id);
            pstmt.setString(2, nome);
            pstmt.setString(3, telefone);
            pstmt.setString(4, cep);
            pstmt.setString(5, rua);
            pstmt.setString(6, numero);
            pstmt.setString(7, bairro);
            pstmt.setString(8, cidade);
            pstmt.setString(9, estado);
            pstmt.setString(10, img);
            //int result = statement.executeUpdate(sql);
            pstmt.execute();
            pstmt.close();
            statement.close();
            connection.close();
            //return result > 0; // Retorna o numero de linhas inseridas caso o insert ocora com sucesso
            return true;
        }catch(SQLException se){
            //Handle errors for JDBC
            se.printStackTrace();
        }catch(Exception e){
            //Handle errors for Class.forName
            e.printStackTrace();
        }finally{
            //finally block used to close resources
            try{
                if(statement !=null)
                    statement.close();
            }catch(SQLException se2){
            }// nothing we can do
            try{
                if(connection !=null)
                    connection.close();
            }catch(SQLException se){
                se.printStackTrace();
            }//end finally try
        }
        return false;
    }

    public boolean deleteRecepcionista(String idin) {
        try{
            start();
            //Execute a query
            System.out.println("Creating statement...");

            statement = connection.createStatement( );

            String sql;
            sql = "DELETE FROM tb_recepcionista WHERE id = "+idin;

            System.out.println(sql);
            /*
            pstmt = connection.prepareStatement(sql);
            pstmt.setString(1, id);
            pstmt.execute();
            System.out.println(sql);
            pstmt.close();
            */
            int result = statement.executeUpdate(sql);
            return result > 0;
        }catch(SQLException se){
            //Handle errors for JDBC
            se.printStackTrace();
        }catch(Exception e){
            //Handle errors for Class.forName
            e.printStackTrace();
        }finally{
            //finally block used to close resources
            try{
                if(statement !=null)
                    statement.close();
            }catch(SQLException se2){
            }// nothing we can do
            try{
                if(connection !=null)
                    connection.close();
            }catch(SQLException se){
                se.printStackTrace();
            }//end finally try
        }
        return false;
    }

    public boolean updateRecepcionista(String id, String newNome) {
        try{
            start();
            //Execute a query
            System.out.println("Creating statement...");

            statement = connection.createStatement( );

            String sql;
            sql = "UPDATE tb_recepcionista SET nome = '"+newNome+"' WHERE id = "+id;
            System.out.println(sql);

            int result = statement.executeUpdate(sql);
            return result > 0;
        }catch(SQLException se){
            //Handle errors for JDBC
            se.printStackTrace();
        }catch(Exception e){
            //Handle errors for Class.forName
            e.printStackTrace();
        }finally{
            //finally block used to close resources
            try{
                if(statement !=null)
                    statement.close();
            }catch(SQLException se2){
            }// nothing we can do
            try{
                if(connection !=null)
                    connection.close();
            }catch(SQLException se){
                se.printStackTrace();
            }//end finally try
        }
        return false;
    }

    private void start() throws ClassNotFoundException, SQLException, IllegalAccessException, InstantiationException {
        //Register JDBC driver
        Class.forName("oracle.jdbc.OracleDriver").newInstance();
        //Open a connection
        System.out.println("Connecting to database...");
        this.connection = DriverManager.getConnection(DB_URL,USER,PASS);
        //Clean-up environment

    }

    public void main(String[] args) {
        this.selectRecepcionista();
        System.out.println("Goodbye!");
    }

    public ArrayList<Object> get(String id) {
        ArrayList<Object> result = new ArrayList<>();
        try{
            start();
            //Execute a query
            System.out.println("Creating statement...");

            statement = connection.createStatement( );

            String sql;
            sql = "SELECT id, nome, foto FROM tb_recepcionista WHERE id = "+id;
            ResultSet rs = statement.executeQuery(sql);
            //System.out.println(rs.wasNull());
            //Extract data from result set
            while(rs.next()){
                //Retrieve by column name
                String nome = rs.getString("nome");
                String resid = rs.getString("id");
                String foto = rs.getString("foto");
                result.add(resid);
                result.add(nome);
                result.add(foto);
            }
            rs.close();
            statement.close();
            connection.close();
        }catch(SQLException se){
            //Handle errors for JDBC
            se.printStackTrace();
        }catch(Exception e){
            //Handle errors for Class.forName
            e.printStackTrace();
        }finally{
            //finally block used to close resources
            try{
                if(statement !=null)
                    statement.close();
            }catch(SQLException se2){
            }// nothing we can do
            try{
                if(connection !=null)
                    connection.close();
            }catch(SQLException se){
                se.printStackTrace();
            }//end finally try
        }
        return result;
    }
}
