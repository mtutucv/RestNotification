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
public class ObterDados {
    
    private String logoUser; //Logotipo do Utilizador Autenticado
    private String nomeUser; //Nome do Utilizador Autenticado
    private String []  link; //conjunto de links da pagina
    private String []  topEmpresas; //Ranking das empresas que fazem anuncios
    private String []  textoValores; //Texto dos dados apresentados 
    private int [] percentagemtopEmpresas; // Percenbtagem das empresas que fazem anuncios
    private int [] valores; // Valor numerico dos dados apresentados
    private String [] percemtagemValores; //Percentagem semanais e darios dos dados apresentados
    
    public ObterDados(int auth,String autKey){
        
      this.link = new String[5];
      this.topEmpresas = new String[5];
      this.textoValores = new String[6];
      this.percentagemtopEmpresas = new int[5];
      this.valores = new int[6];
      this.percemtagemValores = new String[6];
      
      for(int i=0; i < this.textoValores.length; i++)
        this.textoValores[i] = EnumString.getTitleByNumber(i + 1);
      
      if (auth == 1) { 
          
          for(int i=0; i < this.link.length; i++)
            this.link[i] = EnumString.getNamePageByNumber(i + 1);
          
          for(int i=0; i < this.topEmpresas.length; i++)
            this.topEmpresas[i] = "";
          
          for(int i=0; i < this.percentagemtopEmpresas.length; i++)
            this.percentagemtopEmpresas[i] = 0;
          
          Library.getTop5Anunciantes(autKey,topEmpresas,percentagemtopEmpresas);
          
          String dadosTotal = Library.obterTotalUtilizadores(autKey);
          String dadosTotalSemanal = Library.obterTotalUtilizadoresSemanal(autKey);
          
          String totalAnuncios = Library.getTotalAnuncio(autKey);
          String totalAnunciosSemanal = Library.getTotalAnuncioSemanal(autKey);
          double percentagemValoresAnunciosSemanal = 0;
          
          int totalAnunciosPendentes = Library.countPublicidadePendentes(FilesConfig.publicidadeJSON);
          double percentagemAnunciosPendentesSemanal=0;
          
          if(!totalAnuncios.equals("0"))
            percentagemValoresAnunciosSemanal = Double.parseDouble(totalAnunciosSemanal) * 100 / Double.parseDouble(totalAnuncios);
          
          if(totalAnunciosPendentes != 0)
              percentagemAnunciosPendentesSemanal = Double.parseDouble(String.valueOf(Library.countPublicidadePendentesLastWeek(FilesConfig.publicidadeJSON))) * 100 / Double.parseDouble(String.valueOf(totalAnunciosPendentes));
          
          double [] percentagemV = Library.getPercentagemSemanal(dadosTotal, dadosTotalSemanal, 4);
          String [] d = dadosTotal.split(",");
          int [] val = {Integer.parseInt(d[0]),Integer.parseInt(d[1]),Integer.parseInt(d[2]),Integer.parseInt(d[3]),Integer.parseInt(totalAnuncios),totalAnunciosPendentes};
          this.valores = val;
          
          String [] percemtVal = {Library.roud2Decimal(percentagemV[0]),Library.roud2Decimal(percentagemV[1]),Library.roud2Decimal(percentagemV[2]),Library.roud2Decimal(percentagemV[3]),Library.roud2Decimal(percentagemValoresAnunciosSemanal),Library.roud2Decimal(percentagemAnunciosPendentesSemanal)};
          this.percemtagemValores = percemtVal;
          
      } else {
          
          if(auth == 2)
          {
               for(int i=0; i < this.link.length; i++)
                    this.link[i] = EnumString.getNamePageByNumber(0);
                this.link[1] = EnumString.getNamePageByNumber(2);
                this.link[2] = EnumString.getNamePageByNumber(3);
          }else
          {
              
               for(int i=0; i < this.link.length; i++)
                this.link[i] = EnumString.getNamePageByNumber(0);
          }
         
         for(int i=0; i < this.topEmpresas.length; i++)
            this.topEmpresas[i] = "";
          
         for(int i=0; i < this.percentagemtopEmpresas.length; i++)
            this.percentagemtopEmpresas[i] = 0;
         
         for(int i=0; i < this.valores.length; i++)
            this.valores[i] = 0;
        for(int i=0; i < this.percemtagemValores.length; i++)
            this.percemtagemValores[i] = "0";
      }
      
    }

    public String[] getTopEmpresas() {
        return topEmpresas;
    }

    public void setTopEmpresas(String[] topEmpresas) {
        this.topEmpresas = topEmpresas;
    }

    public String[] getTextoValores() {
        return textoValores;
    }

    public void setTextoValores(String[] textoValores) {
        this.textoValores = textoValores;
    }

    public int[] getPercentagemtopEmpresas() {
        return percentagemtopEmpresas;
    }

    public void setPercentagemtopEmpresas(int[] percentagemtopEmpresas) {
        this.percentagemtopEmpresas = percentagemtopEmpresas;
    }

    public int[] getValores() {
        return valores;
    }

    public void setValores(int[] valores) {
        this.valores = valores;
    }

    public String [] getPercemtagemValores() {
        return percemtagemValores;
    }

    public void setPercemtagemValores(String [] percemtagemValores) {
        this.percemtagemValores = percemtagemValores;
    }
    
    public String[] getLink() {
        return link;
    }

    public void setLink(String[] link) {
        this.link = link;
    }

    public String getNomeUser() {
        return nomeUser;
    }
    public void setNomeUser(String nomeUser) {
        this.nomeUser = nomeUser;
    }
    
    public String getLogoUser() {
        return logoUser;
    }
    public void setLogoUser(String logoUser) {
        this.logoUser = logoUser;
    }
}
