---
título: Etapa 001 — Estrutura inicial do app MyWeek
data: 2026-05-09
status: concluída
tags:
  - myweek
  - flutter
  - etapa
---

# Etapa 001 — Estrutura inicial do app MyWeek

## Contexto

Ponto de partida: projeto Flutter vazio com apenas `main.dart` exibindo "Hello World".

Resultado desta etapa: app funcional com duas telas, navegação, estado gerenciado via `provider` e dados de teste em memória.

---

## Dependências adicionadas

| Pacote | Versão | Uso |
|--------|--------|-----|
| `provider` | ^6.1.2 | Gerenciamento de estado com ChangeNotifier |

---

## Arquitetura

Padrão **MVVM** com separação clara de responsabilidades:

| Camada | Responsabilidade |
|--------|-----------------|
| **Model** | Representa os dados, sem regra de negócio |
| **Repository** | Guarda e recupera dados |
| **ViewModel** | Controla estado e regras de cada tela |
| **View** | Interface e chamadas simples ao ViewModel |

> [!info] Preparado para Supabase
> O `MetaRepository` é uma interface (`abstract class`). A implementação atual é em memória. Para integrar com Supabase, basta criar `MetaRepositorySupabase` implementando a mesma interface — sem tocar em ViewModels ou Views.

---

## Arquivos criados

### Core

#### `lib/core/enums/dia_semana.dart`

Enum `DiaSemana` com os 7 dias. Cada valor expõe `.nome` (abreviação) e `.nomeCompleto`.
Função `diaDaData(DateTime)` converte uma data no `DiaSemana` correspondente.

#### `lib/core/enums/origem_meta.dart`

Enum `OrigemMeta`: `manual` ou `recorrente`. Indica como uma meta diária foi criada.

#### `lib/core/utils/gerador_id.dart`

`gerarId()` → ID único baseado em `microsecondsSinceEpoch`.

#### `lib/core/utils/formatador_data.dart`

- `formatarData(DateTime)` → `"Segunda, 09/05"`
- `mesmoDia(DateTime, DateTime)` → compara datas ignorando horário

#### `lib/core/theme/cores_app.dart`

Todas as cores centralizadas em `CoresApp`. Alterar o tema exige mudança em um único lugar.

| Constante | Uso |
|-----------|-----|
| `fundo` | Cor de fundo das telas |
| `fundoCard` | Cor dos cards |
| `primaria` | Verde principal (botões, seleções) |
| `primariaSuave` | Verde claro (dia atual no seletor) |
| `textoPrimario` | Texto principal |
| `textoSecundario` | Texto de suporte / desativado |
| `divisor` | Bordas e linhas divisórias |
| `diaSelecionado` | Fundo do dia selecionado no seletor |
| `diaAtual` | Fundo do dia de hoje no seletor |

---

### Models

#### `lib/models/meta_diaria.dart`

Meta pertencente a uma data específica.

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | String | Identificador único |
| `titulo` | String | Texto da meta |
| `data` | DateTime | Data a que pertence |
| `concluida` | bool | Se foi marcada como feita |
| `origem` | OrigemMeta | `manual` ou `recorrente` |
| `idMetaRecorrente` | String? | ID da recorrência de origem |

#### `lib/models/meta_recorrente.dart`

Meta que se repete em dias fixos da semana.

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | String | Identificador único |
| `titulo` | String | Texto da meta |
| `diasDaSemana` | List\<DiaSemana\> | Dias em que deve aparecer |
| `ativa` | bool | Se gera metas ao abrir o dia |

---

### Repository

#### `lib/data/repositories/meta_repository.dart`

Interface que define o contrato de acesso a dados:

- `buscarMetasDoDia(data)`
- `salvarMetaDiaria(meta)`
- `alternarConclusaoDaMeta(id)`
- `buscarMetasRecorrentes()`
- `salvarMetaRecorrente(meta)`
- `alternarAtivacaoDaMetaRecorrente(id)`
- `removerMetaRecorrente(id)`
- `existeMetaDiariaDaRecorrencia(idMeta, data)`

#### `lib/data/repositories/meta_repository_memoria.dart`

Implementação em memória. Popula dados de teste no construtor:

| Meta recorrente | Dias |
|-----------------|------|
| Faculdade | Segunda a sexta |
| Academia | Segunda, quarta e sexta |
| Estudar programação | Todos os dias |

---

### ViewModels

#### `lib/viewmodels/semana_viewmodel.dart`

Controla a tela principal. Estende `ChangeNotifier`.

| Método | Responsabilidade |
|--------|-----------------|
| `inicializar()` | Seleciona o dia atual ao abrir o app |
| `selecionarDia(dia)` | Troca o dia e recarrega as metas |
| `gerarMetasRecorrentesDoDia(dia)` | Auto-geração das metas recorrentes |
| `adicionarMetaManual(titulo)` | Cria meta manual no dia selecionado |
| `alternarConclusaoDaMeta(id)` | Marca/desmarca conclusão |

> [!note] Lógica de auto-geração
> Ao selecionar um dia:
> 1. Busca metas recorrentes **ativas**
> 2. Filtra as que se aplicam ao dia da semana
> 3. Verifica se já existe meta diária daquela recorrência naquela data
> 4. Se não existir → cria automaticamente
> 5. Carrega a lista atualizada

#### `lib/viewmodels/metas_recorrentes_viewmodel.dart`

Controla a tela de metas recorrentes. Estende `ChangeNotifier`.

| Método | Responsabilidade |
|--------|-----------------|
| `carregarMetasRecorrentes()` | Busca e expõe a lista |
| `criarMetaRecorrente(titulo, dias)` | Persiste nova recorrente |
| `alternarAtivacaoDaMetaRecorrente(id)` | Ativa ou desativa |
| `removerMetaRecorrente(id)` | Remove com confirmação |

---

### Views e Widgets

#### Tela: Semana — `lib/views/semana/`

| Arquivo | O que faz |
|---------|-----------|
| `semana_page.dart` | Tela principal: seletor, lista de metas, FAB |
| `widgets/seletor_dias_semana.dart` | Linha rolável com os 7 dias da semana |
| `widgets/card_meta_diaria.dart` | Card com título e checkbox |
| `widgets/formulario_meta_diaria.dart` | BottomSheet para adicionar meta manual |

#### Tela: Metas Recorrentes — `lib/views/metas_recorrentes/`

| Arquivo | O que faz |
|---------|-----------|
| `metas_recorrentes_page.dart` | Lista de metas recorrentes, FAB para criar |
| `widgets/card_meta_recorrente.dart` | Card com título, dias, switch e botão remover |
| `widgets/formulario_meta_recorrente.dart` | BottomSheet com título + seletor de dias |

---

### App e entry point

#### `lib/app/my_week_app.dart`

`MultiProvider` com os dois ViewModels + `MaterialApp` com tema baseado em `CoresApp`. Rota inicial: `SemanaPage`.

#### `lib/main.dart`

```dart
void main() {
  runApp(const MyWeekApp());
}
```

---

## Estrutura de arquivos

```
lib/
├── main.dart
├── app/
│   └── my_week_app.dart
├── core/
│   ├── enums/
│   │   ├── dia_semana.dart
│   │   └── origem_meta.dart
│   ├── utils/
│   │   ├── gerador_id.dart
│   │   └── formatador_data.dart
│   └── theme/
│       └── cores_app.dart
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

## Resultado

> [!success] flutter analyze
> Nenhum erro encontrado.

O app está funcional com `flutter run`. Ao abrir, o dia atual já é selecionado e as metas recorrentes são geradas automaticamente conforme o dia da semana.

---

## Próximos passos

- [ ] Persistência local com `sqflite` ou `shared_preferences`
- [ ] Integração com Supabase
- [ ] Notificações de lembrete
- [ ] Tela de histórico e progresso semanal
