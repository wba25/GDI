package br.com.g7gdi.projeto.GUI;

import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;
import br.com.g7gdi.projeto.API.JDBC;

/**
 * Created by wellington on 20/06/17.
 */
public class App extends JFrame {
    private JPanel contentPane;

    public static void main(String[] args) {
        EventQueue.invokeLater(new Runnable() {
            public void run() {
                try {
                    App frame = new App();

                    frame.setVisible(true);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
    }

    public App() {

        JDBC oracle = new JDBC();

        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setBounds(100, 100, 1500, 533);
        contentPane = new JPanel();
        contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
        setContentPane(contentPane);
        contentPane.setLayout(null);

        // Titulo
        JLabel titulo = new JLabel("GDI - equipe 7 - 2017.1");
        titulo.setBounds(10, 10, 700, 50);
        titulo.setFont(new Font("Tahoma", Font.PLAIN, 24));
        contentPane.add(titulo);

        // Legenda 1
        JLabel lblConfiguraes = new JLabel("Cadastro de Recepcionista:");
        lblConfiguraes.setFont(new Font("Tahoma", Font.BOLD, 14));
        lblConfiguraes.setBounds(20, 80, 490, 20);
        contentPane.add(lblConfiguraes);

        // Legenda 2
        JLabel lbl2 = new JLabel("Consulta:");
        lbl2.setFont(new Font("Tahoma", Font.BOLD, 14));
        lbl2.setBounds(500, 80, 490, 20);
        contentPane.add(lbl2);

        Formulario formulario = new Formulario(oracle);

        JPanel form = (JPanel) formulario.getContentPane();
        form.setBounds(20, 100, 1300, 500);
        contentPane.add(form);
    }

}
