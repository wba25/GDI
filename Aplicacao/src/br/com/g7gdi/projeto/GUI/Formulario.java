package br.com.g7gdi.projeto.GUI;

import javax.imageio.ImageIO;
import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

/**
 * Created by wellington on 20/06/17.
 */

import java.awt.image.BufferedImage;
import java.io.*;
import java.sql.Blob;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Objects;

import br.com.g7gdi.projeto.API.JDBC;

public class Formulario extends JFrame {

    private JPanel contentPane;
    private JDBC banco;

    private JTextField fieldCEP;
    private JTextField fieldNumero;
    private JTextField fieldBairro;
    private JTextField fieldRua;
    private JTextField fieldEstado;
    private JTextField fieldCidade;

    private JTextField fieldID;
    private JTextField fieldNome;
    private JTextField fieldTel;

    private JTextArea consulta;

    private JButton insertBtn;
    private JButton updateBtn;
    private JButton pesquisaBtn;
    private JButton consultaBtn;
    private JButton deleteBtn;
    private JButton carregarFotoButton;


    private JFileChooser chooser;
    private BufferedImage img;
    private JButton button2;
    private File file ;
    private JLabel label;
    private String path;


    public Formulario(JDBC bc) {
        this.banco = bc;
        setup();
    }

    /**
     * Launch the application.
     */

    public JPanel getPanel(){
        return contentPane;
    }

    public static void main(String[] args) {
        JDBC bc = new JDBC();
        EventQueue.invokeLater(new Runnable() {
            public void run() {
                try {
                    Formulario frame = new Formulario(bc);
                    frame.setVisible(true);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
    }

    /**
     * Create the frame.
     */
    private void setup(){
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setBounds(100, 100, 1300, 500);
        contentPane = new JPanel();
        contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
        setContentPane(contentPane);
        contentPane.setLayout(null);

        chooser = new JFileChooser();
        label = new JLabel("Image and Text");
        //label.setBounds(570,100,200,200);
        label.setVerticalTextPosition(JLabel.BOTTOM);
        label.setHorizontalTextPosition(JLabel.RIGHT);
        contentPane.add(label);

        /*
        chooser = new JFileChooser();
        label = new JLabel();
        JPanel secpanel = new JPanel();
        setVisible(true);
        JRootPane compPane = contentPane.getRootPane();
        Container contePane = compPane.getContentPane();
        secpanel.setBounds(570,100,200,200);
        contePane.add(secpanel);
        secpanel.add(label,BorderLayout.CENTER);*/

        JLabel lblid = new JLabel("ID");
        lblid.setBounds(20, 20, 120, 20);
        contentPane.add(lblid);

        fieldID = new JTextField();
        fieldID.setBounds(186, 20, 250, 20);
        fieldID.setText("");
        contentPane.add(fieldID);
        fieldID.setColumns(50);

        JLabel lblNome = new JLabel("Nome");
        lblNome.setBounds(20, 50, 120, 20);
        contentPane.add(lblNome);

        fieldNome = new JTextField();
        fieldNome.setBounds(186, 50, 250, 20);
        fieldNome.setText("");
        contentPane.add(fieldNome);
        fieldNome.setColumns(10);

        JLabel lblTel = new JLabel("Telefone:");
        lblTel.setBounds(20, 80, 120, 20);
        contentPane.add(lblTel);

        fieldTel = new JTextField();
        fieldTel.setBounds(186, 80, 250, 20);
        fieldTel.setText("");
        contentPane.add(fieldTel);
        fieldTel.setColumns(10);

        JLabel lblCEP = new JLabel("CEP:");
        lblCEP.setBounds(20, 110, 120, 20);
        contentPane.add(lblCEP);

        fieldCEP = new JTextField();
        fieldCEP.setBounds(186, 110, 250, 20);
        fieldCEP.setText("");
        contentPane.add(fieldCEP);
        fieldCEP.setColumns(10);

        JLabel lblNumero = new JLabel("Numero:");
        lblNumero.setBounds(20, 140, 120, 20);
        contentPane.add(lblNumero);

        fieldNumero = new JTextField();
        fieldNumero.setBounds(186, 140, 250, 20);
        fieldNumero.setText("");
        contentPane.add(fieldNumero);
        fieldNumero.setColumns(10);

        JLabel lblbairro = new JLabel("Bairro:");
        lblbairro.setBounds(20, 170, 120, 20);
        contentPane.add(lblbairro);

        fieldBairro = new JTextField();
        fieldBairro.setBounds(186, 170, 250, 20);
        fieldBairro.setText("");
        contentPane.add(fieldBairro);
        fieldBairro.setColumns(10);

        JLabel lblrua = new JLabel("Rua:");
        lblrua.setBounds(20, 200, 250, 20);
        contentPane.add(lblrua);

        fieldRua = new JTextField();
        fieldRua.setBounds(186, 200, 250, 20);
        fieldRua.setText("");
        contentPane.add(fieldRua);
        fieldRua.setColumns(10);

        JLabel lblcid = new JLabel("Cidade:");
        lblcid.setBounds(20, 230, 230, 20);
        contentPane.add(lblcid);

        fieldCidade = new JTextField();
        fieldCidade.setBounds(186, 230, 250, 20);
        fieldCidade.setText("");
        contentPane.add(fieldCidade);
        fieldCidade.setColumns(10);

        JLabel lblestado = new JLabel("Estado:");
        lblestado.setBounds(20, 260, 260, 20);
        contentPane.add(lblestado);

        fieldEstado = new JTextField();
        fieldEstado.setBounds(186, 260, 250, 20);
        fieldEstado.setText("");
        contentPane.add(fieldEstado);
        fieldEstado.setColumns(10);

        JLabel lblfoto = new JLabel("Foto:");
        lblfoto.setBounds(20, 300, 260, 20);
        contentPane.add(lblfoto);

        carregarFotoButton = new JButton("Enviar arquivo");
        carregarFotoButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent arg0) {
                // pega a imagem
                System.out.println("pegou img!");
                chooser.showOpenDialog(null);
                file = chooser.getSelectedFile();
                path = file.getAbsolutePath();
                System.out.println(file.getAbsolutePath());
                // Store image to the table cell

                try{
                    img = ImageIO.read(file);
                    System.out.print(img.toString());
                    ImageIcon icon = new ImageIcon(img);
                    label.setIcon(icon);
                    Dimension imageSize = new Dimension(icon.getIconWidth(),icon.getIconHeight());
                    label.setPreferredSize(imageSize);
                    label.revalidate();
                    label.repaint();

                }catch(IOException e1) {
                    e1.printStackTrace();
                }
            }
        });
        carregarFotoButton.setBounds(186, 300, 250, 23);
        contentPane.add(carregarFotoButton);

        updateBtn = new JButton("Atualizar");
        updateBtn.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent ev) {
                String id = fieldID.getText();
                String nome = fieldNome.getText();
                if(banco.updateRecepcionista(id, nome)) {
                    //if(banco.insertRecepcionista(id,nome,tel,cep,bai,num,cid,rua,estado)) {
                    System.out.println("Recepcionista atualizada com sucesso!");
                }
                else {
                    System.err.println("Recepcionista não atualizada :(");
                }

                // reseta campos
                resetFields();

                // consulta
                try {
                    doQuery();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        });
        updateBtn.setBounds(20, 400, 120, 23);
        contentPane.add(updateBtn);

        consultaBtn = new JButton("Consultar");
        consultaBtn.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent ev) {
                try {
                    doQuery();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        });
        consultaBtn.setBounds(20, 370, 120, 23);
        contentPane.add(consultaBtn);

        pesquisaBtn = new JButton("Procurar");
        pesquisaBtn.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent ev) {
                String id = fieldID.getText();
                ArrayList<Object> result = banco.get(id);
                if(result.size()!=0){
                    consulta.setText("");
                    for(int i =0; i<result.size(); i+=3){
                        path = (String) result.get(i+2);
                        consulta.setText(consulta.getText()+"ID: "+result.get(i)+" Nome: "+result.get(i+1)+" Imagem: "+ path+"\n");

                        File fileout = new File(path);
                        System.out.println(path);
                        // Store image to the table cell

                        try{
                            img = ImageIO.read(fileout);
                            System.out.print(img.toString());
                            ImageIcon icon = new ImageIcon(img);
                            label.setIcon(icon);
                            Dimension imageSize = new Dimension(icon.getIconWidth(),icon.getIconHeight());
                            label.setPreferredSize(imageSize);
                            label.revalidate();
                            label.repaint();

                        }catch(IOException e1) {
                            e1.printStackTrace();
                        }
                    }
                }
                else {
                    consulta.setText("Recepcionita com id "+id+" não encontrada!");
                }

                // reseta campos
                resetFields();
            }
        });
        pesquisaBtn.setBounds(165, 370, 120, 23);
        contentPane.add(pesquisaBtn);


        deleteBtn = new JButton("Deletar");
        deleteBtn.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent ev) {
                String id = fieldID.getText();
                if(banco.deleteRecepcionista(id)) {
                    //if(banco.insertRecepcionista(id,nome,tel,cep,bai,num,cid,rua,estado)) {
                    System.out.println("Recepcionista deletada com sucesso!");
                }
                else {
                    System.err.println("Recepcionista não deletada :(");
                }

                // reseta campos
                resetFields();

                // consulta
                try {
                    doQuery();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        });
        deleteBtn.setBounds(165, 400, 120, 23);
        contentPane.add(deleteBtn);

        insertBtn = new JButton("Casdastrar");
        insertBtn.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent arg0) {
                String id = fieldID.getText();
                String nome = fieldNome.getText();
                String tel = fieldTel.getText();
                String cep = fieldCEP.getText();
                String bai = fieldBairro.getText();
                String num = fieldNumero.getText();
                String estado = fieldEstado.getText();
                String cid = fieldCidade.getText();
                String rua = fieldRua.getText();


                // casdastra
                if(banco.insertRecepcionista(id,nome,tel,cep,bai,num,cid,rua,estado, path)){
                //if(banco.insertRecepcionista(id,nome,tel,cep,bai,num,cid,rua,estado)) {
                    System.out.println("Recepcionista cadastrada com sucesso!");
                }
                else {
                    System.err.println("Recepcionista não cadastrada :(");
                }

                // reseta campos
                resetFields();

                // consulta
                try {
                    doQuery();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }


        });
        insertBtn.setBounds(310, 400, 120, 23);
        contentPane.add(insertBtn);


        consulta = new JTextArea(5, 20);
        JScrollPane scrollPane = new JScrollPane(consulta);
        consulta.setEditable(false);
        consulta.setBounds(500, 0, 400, 400);
        consulta.setText("Suas consultas apareceram aqui ...");
        contentPane.add(consulta);

        label = new JLabel("Foto");

        JTextArea ftn = new JTextArea(5, 20);
        JScrollPane scrollPane2 = new JScrollPane(label);
        label.setBounds(950, 0, 200, 200);
        label.setText("Foto da recepcionista ...");
        contentPane.add(label);
    }



    private void doQuery() throws SQLException {
        ArrayList<Object> aux = banco.selectRecepcionista();
        consulta.setText("");
        for(int i =0; i<aux.size(); i+=3){
            consulta.setText(consulta.getText()+"ID: "+aux.get(i)+" Nome: "+aux.get(i+1)+" Imagem: "+ aux.get(i+2)+"\n");
            /*
            ImageIcon img = null;
            try {
                blob.getBytes()
                img = new ImageIcon(blob.getBytes(1, (int)blob.length()));
            } catch (SQLException e) {
                e.printStackTrace();
            }
            System.out.println("ID: "+aux.get(i)+" Nome: "+aux.get(i+1)+" Imagem: "+img.getDescription());
            */
        }
    }

    public void resetFields() {
        fieldID.setText("");
        fieldNome.setText("");
        fieldTel.setText("");
        fieldCEP.setText("");
        fieldBairro.setText("");
        fieldNumero.setText("");
        fieldEstado.setText("");
        fieldCidade.setText("");
        fieldRua.setText("");
    }
}
