package Model;

import java.util.ArrayList;

/**
 * Created by wellington on 17/06/17.
 */
public class Medico {
    private int crm;
    private String nome;
    private ArrayList<Telefone> telefones;
    private Endereco endereco;
    private Consultorio consultorio;

    public Medico(int crm, String nome, ArrayList<Telefone> telefones, Endereco endereco, Consultorio consultorio) {
        this.crm = crm;
        this.nome = nome;
        this.telefones = telefones;
        this.endereco = endereco;
        this.consultorio = consultorio;
    }

    public int getCrm() { return crm; }

    public void setCrm(int crm) {
        this.crm = crm;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public ArrayList<Telefone> getTelefones() {
        return telefones;
    }

    public void setTelefones(ArrayList<Telefone> telefones) {
        this.telefones = telefones;
    }

    public Endereco getEndereco() {
        return endereco;
    }

    public void setEndereco(Endereco endereco) {
        this.endereco = endereco;
    }

    public Consultorio getConsultorio() {
        return consultorio;
    }

    public void setConsultorio(Consultorio consultorio) {
        this.consultorio = consultorio;
    }
}
