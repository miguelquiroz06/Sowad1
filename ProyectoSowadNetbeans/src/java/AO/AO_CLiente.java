/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package AO;

/**
 *
 * @author Miguel Quiroz
 */
public class AO_CLiente {
    
    private String idCliente;
    private String Nombres;
    private String Apellido;
    private String Telefono;
    private String Usuario;
    private String Contraseña;
    
    public AO_CLiente() {
    }

    public AO_CLiente(String idCliente, String Nombres, String Apellido, String Telefono, String Usuario, String Contraseña) {
        this.idCliente = idCliente;
        this.Nombres = Nombres;
        this.Apellido = Apellido;
        this.Telefono = Telefono;
        this.Usuario = Usuario;
        this.Contraseña = Contraseña;
    }



    public String getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(String idCliente) {
        this.idCliente = idCliente;
    }

    public String getNombres() {
        return Nombres;
    }

    public void setNombres(String Nombres) {
        this.Nombres = Nombres;
    }

    public String getApellido() {
        return Apellido;
    }

    public void setApellido(String Apellido) {
        this.Apellido = Apellido;
    }

    public String getTelefono() {
        return Telefono;
    }

    public void setTelefono(String Telefono) {
        this.Telefono = Telefono;
    }

    public String getUsuario() {
        return Usuario;
    }

    public void setUsuario(String Usuario) {
        this.Usuario = Usuario;
    }

    public String getContraseña() {
        return Contraseña;
    }

    public void setContraseña(String Contraseña) {
        this.Contraseña = Contraseña;
    }


    
}

