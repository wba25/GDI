package br.com.g7gdi.projeto.GUI;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

/**
 * Created by Ezequiel Reis on 16/06/2017.
 */
public class JanelaPrincipal {
    private JPanel JanelaPrincipal;
    private JButton novoPacienteButton;
    private JButton novoMédicoButton;
    private JButton marcarConsultaButton;

    public JanelaPrincipal() {
        novoPacienteButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {

                NovoPaciente np = new NovoPaciente();
            }
        });
    }

    public static void main(String[] args) {
        JFrame frame = new JFrame("JanelaPrincipal");
        frame.setContentPane(new JanelaPrincipal().JanelaPrincipal);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.pack();
        frame.setVisible(true);
    }
}