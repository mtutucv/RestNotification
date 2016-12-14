/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mtutucv;

/**
 *
 * @author Mário Monteiro - 77910
 */
public class EnumString {
/***
 * Devolve um ID do tipo de anuncio de acordo com o tipo em texto
 * @param tipo - tipo em tetxo
 * @return - um ID
 */
public static int tipoAnuncio(String tipo){

    if(tipo == null)
        return -1;
    if(tipo.equals("Anuncio Anual"))
          return 1; 
    else if(tipo.equals("Anuncio Simples"))
        return 2;
    else if(tipo.equals("Anuncio diario"))
        return 3;  

    return -1;
}
/***
 * Devolve um titulo das estatisticas do Dashboard de acordo com um ID enviado
 * @param titulo - ID do titulo da Estatistica do Dashboard
 * @return 
 */
public static String getTitleByNumber(int titulo){

    switch(titulo){
        case 1:
            return "Total de Utilizadores";
        case 2:
             return "Total Masculino";
        case 3:
             return "Total Feminino";
        case 4:
             return "Total Unisexo";
        case 5:
             return "An&uacute;ncios";
        case 6:
            return "An&uacute;ncios Pendentes";
    }
    return null;
}
/***
 * Devolve o nome da pagina de acordo com um ID atribuido a cada uma delas
 * @param titulo - ID da pagina
 * @return 
 */
public static String getNamePageByNumber(int titulo){

    switch(titulo){
        case 1:
            return "dashbord1.jsp";
        case 2:
             return "anuncio.jsp";
        case 3:
             return "empresa.jsp";
        case 4:
             return "user.jsp";
        case 5:
             return "config.jsp";
        case 6:
            return "dashbord2.jsp";
        case 7:
            return "logout.jsp";
        case 8:
            return "index.jsp";
        case 9:
            return "showAnuncio.jsp";
        case 10:   
            return "update.jsp";
        case 11:   
            return "menu.jsp";
        default:
             return "#";
    }
}

/***
 * Devolve o nome do perfil de acordo com o ID para cada uma delas
 * @param perfil
 * @return 
 */
public static String getPerfilByNumber(int perfil)
{
    switch(perfil){
        case 1:
            return "Administrator";
        case 2:
             return "Empresa";
        case 3:
             return "Anonimo";
        default:
             return "";
    }
}
public static String getIconByNumber(int icon)
{
    switch(icon){
        case 1:
            return "success-icon.png";
        case 2:
             return "errorICON.png";
        case 3:
             return "alertICON.jpg";
        default:
             return "";
    }
}
public static String getMsgByNumber(int perfil)
{
    switch(perfil){
        case 1:
            return "Publicidade Guardada com Sucesso!";
        case 2:
             return "Erro ao Guardar a publicidade!";
        case 3:
             return "Publicidade Enviada com Sucesso!";
        case 4:
             return "Erro no Envio da Publicidade!";
        case 5:
             return "N&atilde;o Possui Saldo ou Credito Suficiente por isso o anuncio não foi enviado!";
        case 6:
             return "Empresa Guardada com Sucesso!";
        case 7:
             return "Erro ao Guardar a Empresa!";
        case 8:
             return "Configura&ccedil;&atilde;o alterada com sucesso!";
        default:
             return "#";
    }
}
}
