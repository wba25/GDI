package Model;

import java.sql.Timestamp;
import java.util.ArrayList;

/**
 * Created by wellington on 17/06/17.
 */
public class Paciente {
    private String cpf;
    private String nome;
    private char sexo;
    private Timestamp data_nascimento;
    private String plano_de_saude;
    private ArrayList<Telefone> telefones;
    private Endereco endereco;

    public Paciente(String cpf, String nome, char sexo, Timestamp data_nascimento, String plano_de_saude, ArrayList<Telefone> telefones, Endereco endereco) {
        this.cpf = cpf;
        this.nome = nome;
        this.sexo = sexo;
        this.data_nascimento = data_nascimento;
        this.plano_de_saude = plano_de_saude;
        this.telefones = telefones;
        this.endereco = endereco;
    }


    public String getCpf() { return cpf; }

    public void setCpf(String cpf) {
        this.cpf = cpf;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public char getsexo() { return sexo; }

    public void setSexo(char sexo) {
        this.sexo = sexo;
    }

    public Timestamp getData_nascimento() { return data_nascimento; }

    public void setData_nascimento(Timestamp data_nascimento) {
        this.data_nascimento = data_nascimento;
    }

    public String getPlano_de_saude() { return plano_de_saude; }

    public void setPlano_de_saude(String plano_de_saude) {
        this.plano_de_saude = plano_de_saude;
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
}
