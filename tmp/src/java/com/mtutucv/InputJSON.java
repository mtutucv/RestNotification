/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mtutucv;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author Mário Monteiro - 77910
 */

@XmlRootElement
public class InputJSON {
    private @XmlElement String contato;
    private @XmlElement String conteudo;
    private @XmlElement String tipo;

    public String getContato() {
        return contato;
    }

    public String getConteudo() {
        return conteudo;
    }

    public String getTipo() {
        return tipo;
    }
    
    
}
