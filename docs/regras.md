O app será minimalista, organizado e de fácil entendimento. O objetivo é permitir que o usuário planeje e acompanhe metas da semana e metas diárias.

Nesta primeira versão, os dados devem ficar salvos apenas no estado local do app, sem persistência em banco. Porém, a arquitetura deve estar preparada para futuramente integrar com Supabase.

Use arquitetura MVVM, código limpo, declarativo e com variáveis em português.

Evite funções com múltiplas responsabilidades. Cada função deve fazer apenas uma ação clara.

A parte de cores do tema, deixe centralizado em um arquivo para alteraçoes facilitadas de cores

## Objetivo do app

O usuário poderá:

1. Visualizar a semana atual.
2. Selecionar um dia da semana.
3. Ver as metas daquele dia.
4. Marcar metas como concluídas.
5. Adicionar metas manuais no dia.
6. Cadastrar metas recorrentes.
7. Definir em quais dias da semana uma meta recorrente deve aparecer.
8. Ao abrir um dia, o app deve adicionar automaticamente as metas recorrentes daquele dia, caso ainda não tenham sido adicionadas.

## Exemplo de uso

O usuário cadastra:

- Faculdade: segunda a sexta
- Academia: segunda, quarta e sexta

Quando ele abrir segunda-feira, o app deve mostrar automaticamente:

- Faculdade
- Academia

Quando abrir terça-feira:

- Faculdade

Quando abrir quarta-feira:

- Faculdade
- Academia

## Regras do app

### Regras de metas diárias

- Uma meta diária pertence a uma data específica.
- Uma meta diária possui:
  - id
  - título
  - data
  - concluída
  - origem: manual ou recorrente
  - id da meta recorrente, caso tenha sido criada a partir de uma recorrência

### Regras de metas recorrentes

- Uma meta recorrente não pertence a uma data específica.
- Ela define em quais dias da semana deve aparecer.
- Uma meta recorrente possui:
  - id
  - título
  - dias da semana
  - ativa

### Regra de geração automática

Ao acessar um dia:

1. Buscar as metas recorrentes ativas.
2. Verificar quais pertencem ao dia da semana selecionado.
3. Verificar se já existe uma meta diária criada para aquela data a partir da recorrência.
4. Caso não exista, criar a meta diária automaticamente.
5. Não duplicar metas recorrentes no mesmo dia.

## Arquitetura MVVM

Use a seguinte estrutura:

lib/
  main.dart

  app/
    my_week_app.dart

  core/
    enums/
      dia_semana.dart
      origem_meta.dart

    utils/
      gerador_id.dart
      formatador_data.dart

  models/
    meta_diaria.dart
    meta_recorrente.dart

  data/
    repositories/
      meta_repository.dart
      meta_repository_memoria.dart

  viewmodels/
    semana_viewmodel.dart
    metas_recorrentes_viewmodel.dart

  views/
    semana/
      semana_page.dart
      widgets/
        seletor_dias_semana.dart
        card_meta_diaria.dart
        formulario_meta_diaria.dart

    metas_recorrentes/
      metas_recorrentes_page.dart
      widgets/
        card_meta_recorrente.dart
        formulario_meta_recorrente.dart

## Responsabilidades

### Models

Os models devem representar apenas os dados.

Não colocar regra de negócio complexa dentro dos models.

### Repository

O repository deve ser responsável por guardar e recuperar dados.

Nesta primeira versão, use um repository em memória.

No futuro, esse repository poderá ser substituído por uma implementação usando Supabase.

Crie uma interface:

MetaRepository

E uma implementação:

MetaRepositoryMemoria

### ViewModels

Os ViewModels devem controlar o estado e as regras da tela.

Use ChangeNotifier nesta primeira versão.

O SemanaViewModel deve cuidar de:

- dia selecionado
- lista de metas do dia
- seleção de dia
- criação de meta manual
- marcação de meta como concluída
- geração automática das metas recorrentes

O MetasRecorrentesViewModel deve cuidar de:

- listar metas recorrentes
- criar meta recorrente
- ativar ou desativar meta recorrente
- remover meta recorrente

### Views

As views devem conter apenas interface e chamadas simples para o ViewModel.

Evite regra de negócio dentro das telas.

## Telas

### Tela principal da semana

A tela principal deve mostrar:

- Nome do app: My Week
- Seletor de dias da semana
- Data do dia selecionado
- Lista de metas do dia
- Checkbox para concluir meta
- Botão para adicionar meta manual
- Atalho para tela de metas recorrentes

### Tela de metas recorrentes

A tela deve mostrar:

- Lista de metas recorrentes
- Dias em que cada meta aparece
- Opção para criar nova meta recorrente
- Opção para ativar/desativar meta recorrente

## Estilo visual

O app deve ser minimalista.

Use:

- Cores suaves
- Espaçamentos generosos
- Poucos elementos por tela
- Textos claros
- Cards simples
- Ícones discretos
- Interface fácil de entender

Evite excesso visual.

## Padrão de código

Use nomes em português.

Exemplos:

- MetaDiaria
- MetaRecorrente
- SemanaViewModel
- metasDoDia
- diaSelecionado
- adicionarMetaManual
- gerarMetasRecorrentesDoDia
- alternarConclusaoDaMeta

As funções devem ser pequenas e objetivas.

Evite funções que fazem várias coisas ao mesmo tempo.

Exemplo ruim:

salvarMetaEAtualizarTelaEGerarRecorrencias()

Exemplo bom:

salvarMeta()
atualizarMetasDoDia()
gerarMetasRecorrentesDoDia()

## Estado inicial para teste

Ao iniciar o app, criar algumas metas recorrentes em memória:

- Faculdade: segunda a sexta
- Academia: segunda, quarta e sexta
- Estudar programação: todos os dias

Esses dados servem apenas para teste inicial.

## Importante

A arquitetura deve facilitar a troca futura do armazenamento local pelo Supabase.

Não acoplar a interface diretamente ao banco ou ao Supabase.

Toda comunicação com dados deve passar pelo Repository.

Minha sugestão: comece criando primeiro models + repository em memória + SemanaViewModel. Depois a interface fica bem mais simples, porque a regra principal do app já estará organizada.