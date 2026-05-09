---
título: Regras e especificação — MyWeek
data: 2026-05-09
status: ativa
tags:
  - myweek
  - flutter
  - especificação
---

# Regras e especificação — MyWeek

## Visão geral

App minimalista para planejamento e acompanhamento de metas semanais e diárias.

> [!info] Armazenamento
> Nesta primeira versão, os dados ficam salvos apenas no estado local do app, sem persistência em banco. A arquitetura deve estar preparada para futuramente integrar com **Supabase**.

---

## Objetivo do app

O usuário poderá:

1. Visualizar a semana atual
2. Selecionar um dia da semana
3. Ver as metas daquele dia
4. Marcar metas como concluídas
5. Adicionar metas manuais no dia
6. Cadastrar metas recorrentes
7. Definir em quais dias da semana uma meta recorrente deve aparecer
8. Ao abrir um dia, o app deve adicionar automaticamente as metas recorrentes daquele dia, caso ainda não tenham sido adicionadas

---

## Exemplo de uso

O usuário cadastra:

- **Faculdade** → segunda a sexta
- **Academia** → segunda, quarta e sexta

| Dia | Metas exibidas |
|-----|----------------|
| Segunda | Faculdade, Academia |
| Terça | Faculdade |
| Quarta | Faculdade, Academia |
| Quinta | Faculdade |
| Sexta | Faculdade, Academia |

---

## Modelos de dados

### MetaDiaria

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | String | Identificador único |
| `titulo` | String | Texto da meta |
| `data` | DateTime | Data a que pertence |
| `concluida` | bool | Se foi marcada como feita |
| `origem` | OrigemMeta | `manual` ou `recorrente` |
| `idMetaRecorrente` | String? | ID da recorrência de origem (se aplicável) |

> [!note] Regra
> Uma meta diária pertence a uma **data específica**.

### MetaRecorrente

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | String | Identificador único |
| `titulo` | String | Texto da meta |
| `diasDaSemana` | List\<DiaSemana\> | Dias em que deve aparecer |
| `ativa` | bool | Se está gerando metas ao abrir o dia |

> [!note] Regra
> Uma meta recorrente **não pertence a uma data específica**. Ela define em quais dias da semana deve aparecer.

---

## Regra de geração automática

Ao acessar um dia:

1. Buscar as metas recorrentes **ativas**
2. Verificar quais pertencem ao dia da semana selecionado
3. Verificar se já existe uma meta diária criada para aquela data a partir da recorrência
4. Caso não exista → criar a meta diária automaticamente
5. **Não duplicar** metas recorrentes no mesmo dia

---

## Arquitetura MVVM

```
lib/
├── main.dart
├── app/
│   └── my_week_app.dart
├── core/
│   ├── enums/
│   │   ├── dia_semana.dart
│   │   └── origem_meta.dart
│   └── utils/
│       ├── gerador_id.dart
│       └── formatador_data.dart
├── models/
│   ├── meta_diaria.dart
│   └── meta_recorrente.dart
├── data/
│   └── repositories/
│       ├── meta_repository.dart
│       └── meta_repository_memoria.dart
├── viewmodels/
│   ├── semana_viewmodel.dart
│   └── metas_recorrentes_viewmodel.dart
└── views/
    ├── semana/
    │   ├── semana_page.dart
    │   └── widgets/
    │       ├── seletor_dias_semana.dart
    │       ├── card_meta_diaria.dart
    │       └── formulario_meta_diaria.dart
    └── metas_recorrentes/
        ├── metas_recorrentes_page.dart
        └── widgets/
            ├── card_meta_recorrente.dart
            └── formulario_meta_recorrente.dart
```

---

## Responsabilidades por camada

### Models

- Representam apenas os dados
- Não contêm regras de negócio complexas

### Repository

- Responsável por guardar e recuperar dados
- Nesta versão: implementação em memória
- Interface `MetaRepository` → implementação `MetaRepositoryMemoria`

> [!tip] Extensibilidade
> No futuro, o `MetaRepositoryMemoria` poderá ser substituído por `MetaRepositorySupabase` implementando a mesma interface, sem alterar ViewModels ou Views.

### ViewModels

Usam `ChangeNotifier`.

#### SemanaViewModel

| Responsabilidade |
|-----------------|
| Dia selecionado |
| Lista de metas do dia |
| Seleção de dia |
| Criação de meta manual |
| Marcação de meta como concluída |
| Geração automática das metas recorrentes |

#### MetasRecorrentesViewModel

| Responsabilidade |
|-----------------|
| Listar metas recorrentes |
| Criar meta recorrente |
| Ativar ou desativar meta recorrente |
| Remover meta recorrente |

### Views

- Contêm apenas interface
- Fazem chamadas simples ao ViewModel
- Sem regra de negócio nas telas

---

## Telas

### Tela principal — Semana

Exibe:

- Nome do app: **My Week**
- Seletor de dias da semana
- Data do dia selecionado
- Lista de metas do dia
- Checkbox para concluir meta
- Botão para adicionar meta manual
- Atalho para tela de metas recorrentes

### Tela de metas recorrentes

Exibe:

- Lista de metas recorrentes
- Dias em que cada meta aparece
- Opção para criar nova meta recorrente
- Opção para ativar/desativar meta recorrente

---

## Estilo visual

> [!tip] Princípio
> Minimalista. Poucos elementos por tela, espaço generoso, fácil de entender.

- Cores suaves
- Espaçamentos generosos
- Poucos elementos por tela
- Textos claros
- Cards simples
- Ícones discretos
- Evitar excesso visual

---

## Padrão de código

- Nomes de variáveis, funções e classes em **português**
- Funções pequenas e com responsabilidade única

| ❌ Ruim | ✅ Bom |
|--------|-------|
| `salvarMetaEAtualizarTelaEGerarRecorrencias()` | `salvarMeta()` |
| | `atualizarMetasDoDia()` |
| | `gerarMetasRecorrentesDoDia()` |

Exemplos de nomes corretos:

```dart
MetaDiaria
MetaRecorrente
SemanaViewModel
metasDoDia
diaSelecionado
adicionarMetaManual
gerarMetasRecorrentesDoDia
alternarConclusaoDaMeta
```

---

## Estado inicial para teste

Ao iniciar o app, criar em memória:

| Meta | Dias |
|------|------|
| Faculdade | Segunda a sexta |
| Academia | Segunda, quarta e sexta |
| Estudar programação | Todos os dias |

> [!warning] Atenção
> Esses dados existem apenas para validação visual durante o desenvolvimento.

---

## Regras importantes

> [!warning] Acoplamento proibido
> A interface **não deve ser acoplada diretamente** ao banco ou ao Supabase. Toda comunicação com dados deve passar pelo **Repository**.

- Usar arquitetura MVVM
- Código limpo, declarativo, variáveis em português
- Cores do tema centralizadas em um único arquivo
- Evitar funções com múltiplas responsabilidades
- Cada função deve fazer apenas uma ação clara
