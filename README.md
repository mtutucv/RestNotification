# RestNotification
O sisteme consistem em uma API REST que envia notificação por quatro canais distintos:

- 1 - E-mail - envia um determinado conteudo para um contacto de email valido fornecido
- 2 - SMS - Utiliza a API da Click Send, que pode ser alterada no ficheiro config ou no Dashboard
- 3 - XMPP - utiliza o protocolo XMPP, atraves de um servidor da google, por isso esta notificação é valido para enviar a um contacto valido de um e-mail da google, a sua configuração pode ser alterada na config.json, ou na Dashboard
- 4 - Push Notification - utiliza o Firebase Cloud Messaging da google para fazer uma notificação a uma aplicação android num Smartphone, a sua configuração pode ser alterada na config.json, ou na Dashboard
Tecnologias todo o sistema é desenvolvido sobre a tecnologia JAVA, java 1.8 (jdk1.8.0_101), e a tecnologia Web deve ser feito o deploy sobre o GlasFish (GlassFish_Server4.1.0)

Arquivos de configuração, todos os arquivos de configuração JSON devem ser copiados a pasta (GlassFish_Server4.1.0\glassfish\domains\domain1\config)

Comsumir a API Rest da Notificação URL : http:///WebServicesREST/webresources/Notify/NotifyByAll JSON : { "contato": , "conteudo":, "tipo": }

Tipo de Notificação é uma String numerica de 1 a 4 (1 - Email, 2 - SMS, 3 - XMPP, 4 - Push Notification)

A dashboard para ser visualizada deve ser feita apartir da http:///WebServicesREST/

No DashBoard além da visualização de diversos conteudos estatisticos relacionados com a aplicação de notificação de publicidades, e feita um conjunto de configurações tais como:
 - Empresas - Potenciais empresas que farão a notificação das suas publicidades.
 - Utilizadores - os utilizadores autenticam-se no sistema através de Facebook, Gmail, Instagram, e é necessario configurar as suas permissões e essa deve ser feita na Dashboard, o utilizador Admin principal deve ser adicionado na config, ou seja apos autenticar no sistema é obtido um id do utilizador e este ID pode ser adicionado como Admin na config.
 - Configurações - todas as configurações do ficheiro config pode se alterada na Dashboard.
