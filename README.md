# Management Mobile

Management Mobile é um aplicativo de inventário de equipamentos, desenvolvido por mim como parte de um projeto para avaliação de habilidades em desenvolvimento mobile. O objetivo do projeto foi criar um sistema eficiente que utiliza QR codes para autenticação e gerenciamento de dados, garantindo usabilidade e funcionalidade completas.

---

## 🚀 Funcionalidades Principais

### 1. **Login**
- Tela de login simples onde os usuários podem autenticar-se com:
  - **Admin padrão:** 
    - **Usuário:** `99999999999` 
    - **Senha:** `admin123`
- Após um login bem-sucedido:
  - As credenciais são validadas.
  - O sistema redireciona o usuário para a **listagem de equipamentos vinculados**.

---

### 2. **Listagem de Equipamentos**
- Exibe uma lista de equipamentos vinculados ao usuário logado, contendo:
  - Nome do equipamento.
  - Código do equipamento.
  - Data do último inventário.
  - Indicador de validade do inventário:
    - **Válido:** Se o inventário foi realizado nos últimos 30 dias.
    - **Inválido:** Se o inventário excedeu 30 dias.
- Botão para realizar um novo inventário de cada equipamento.

---

### 3. **Realizar Inventário**
- Ao acionar o botão de "Novo Inventário":
  - Abre uma tela para leitura de **QR code**.
  - Após uma leitura bem-sucedida:
    - Atualiza a data do inventário para a data atual.
    - Refresca a lista de equipamentos na tela inicial.

---

### 4. **Administração**
- Acessível apenas para o administrador (usuário padrão `99999999999`):
  - Leitura de **QR code** para identificar um equipamento.
  - Vinculação de equipamentos a usuários existentes.
  - Exclusão de equipamentos não vinculados.
- Equipamentos vinculados aparecem automaticamente na lista do usuário correspondente.

---

## ⚙️ Requisitos Técnicos
- **Plataforma:** Android e iOS.
- **Banco de Dados Local:** Persistência de dados offline.

---

## 🛠️ Tecnologias Utilizadas
- **Framework:** Flutter
- **Gerenciamento de Estado:** MVVM ou similar
- **Leitor de QR Code:** `flutter_qr_bar_scanner` 
- **Banco de Dados Local:** SQLite
- **Ferramenta para Geração de QR Code:** [QR.io](https://qr.io/)

---

## 🎯 Como Gerar QR Codes
1. Acesse o site [QR.io](https://qr.io/).
2. Escolha o tipo **Texto**.
3. Insira as informações do equipamento no formato **JSON**:
   ```json
   {
     "nome": "1203",
     "descricao": "Notebook Dell",
     "codigo": "12EE"
   }
   ```

---

## 📋 Critérios de Avaliação Atendidos
1. **Funcionalidades:** 
   - Implementação completa de login, listagem, inventário e administração.
2. **Usabilidade:**
   - Design simples e intuitivo.
   - Fluxo de navegação funcional e eficiente.
3. **Código:**
   - Estrutura organizada e aderente a boas práticas.
   - Uso de padrões de projeto como MVVM para modularidade.
4. **Tecnologias:**
   - Implementação eficiente do leitor de QR codes e banco de dados offline.

---

## 📝 Como Executar
1. Clone o repositório:
   ```bash
   git clone <URL_DO_REPOSITORIO>
   ```
2. Acesse o diretório do projeto:
   ```bash
   cd management_mobile
   ```
3. Instale as dependências:
   ```bash
   flutter pub get
   ```
4. Execute o aplicativo:
   ```bash
   flutter run
   ```
5. Para compilar o APK de debug:
   ```bash
   flutter build apk --debug
   ```

---

## 🎥 Demonstração (Opcional)
- Adicione um vídeo curto demonstrando as principais funcionalidades do sistema.

---

## 📂 Estrutura do Projeto
- **lib/**: Código-fonte principal.
- **assets/**: Recursos estáticos (imagens, ícones, etc.).
- **android/**: Configurações específicas do Android.
- **ios/**: Configurações específicas do iOS.

---

## 📜 Licença
Este projeto foi desenvolvido por mim como parte de um teste técnico e não possui licença de distribuição.

---

Obrigado por conferir o projeto! 🚀
