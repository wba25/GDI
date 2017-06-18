package Model;

import java.util.ArrayList;

/**
 * Created by Ezequiel Reis on 18/06/2017.
 */
public class Recepcionista {
    private int id;
    private String nome;
    private ArrayList<Telefone> telefones;
    private Endereco endereco;

    public Recepcionista(int id, String nome, ArrayList<Telefone> telefones, Endereco endereco){
        this.id = id;
        this.nome = nome;
        this.telefones = telefones;
        this.endereco = endereco;
    }

}

