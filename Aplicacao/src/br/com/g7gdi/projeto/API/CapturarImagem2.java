package br.com.g7gdi.projeto.API;

import java.awt.BorderLayout;
import java.awt.Container;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JRootPane;

//carrega a imagem na mesma janela do botão
@SuppressWarnings("serial")
public class CapturarImagem2 extends JFrame implements ActionListener{
    JFileChooser chooser;
    BufferedImage img;
    JButton button2;
    File file ;
    JLabel label;
    public CapturarImagem2(){
        super("Capturar Imagem");
        setSize(450,450);//tamanho da janela
        JPanel panel = new JPanel();
        panel.setLayout(new BorderLayout());
        getContentPane().add(panel);
        chooser = new JFileChooser();
        label = new JLabel();
        JPanel secpanel = new JPanel();
        setVisible(true);
        JRootPane compPane = panel.getRootPane();
        Container contePane = compPane.getContentPane();
        contePane.add(secpanel);
        secpanel.add(label,BorderLayout.CENTER);
        button2=new JButton("carregar imagem");
        button2.addActionListener(this);
        panel.add(button2,BorderLayout.SOUTH);
    }
    protected static ImageIcon createImageIcon(String path) {
        java.net.URL imgURL = CapturarImagem2.class.getResource(path);
        if (imgURL != null) {
            return new ImageIcon(imgURL);
        } else {
            System.err.println("Não foi possível encontrar o arquivo: " + path);
            return null;
        }
    }
    @Override
    public void actionPerformed(ActionEvent e) {
        if (e.getSource() == button2){
            chooser.showOpenDialog(null);
            file = chooser.getSelectedFile();
            try{
                img=ImageIO.read(file);
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
    public static void main(String[] args) {
        new CapturarImagem2();
    }
}
