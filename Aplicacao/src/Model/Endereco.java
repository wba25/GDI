package Model;

/**
 * Created by wellington on 17/06/17.
 */
public class Endereco {
    private int cep;
    private String logradouro;
    private int numero;
    private String bairro;
    private String cidade;
    private String estado;

    public Endereco(int cep, String logradouro, int numero, String bairro, String cidade, String estado) {
        this.cep = cep;
        this.logradouro = logradouro;
        this.numero = numero;
        this.bairro = bairro;
        this.cidade = cidade;
        this.estado = estado;
    }

    public int getCep() { return cep; }

    public void setCep(int cep) { this.cep = cep; }

    public String getLogradouro() { return logradouro; }

    public void setLogradouro(String logradouro) {
        this.logradouro = logradouro;
    }

    public int getNumero() { return numero; }

    public void setNumero(int numero) { this.numero = numero; }

    public String getBairro() { return bairro; }

    public void setBairro(String bairro) {
        this.bairro = bairro;
    }

    public String getCidade() { return cidade; }

    public void setCidade(String cidade) {
        this.cidade = cidade;
    }

    public String getEstado() { return estado; }

    public void setEstado(String estado) {
        this.estado = estado;
    }
}
