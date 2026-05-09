---
título: Etapa 002 — Tela inicial, navbar e configurações
data: 2026-05-09
status: concluída
tags:
  - myweek
  - flutter
  - etapa
---

# Etapa 002 — Tela inicial, navbar e configurações

## Contexto

O app abria direto na `SemanaPage`. Esta etapa adiciona uma tela inicial com saudação dinâmica por período do dia, indicador de progresso das metas de hoje, card com total da semana, navegação por bottom navbar e uma tela de configurações estruturada.

---

## Comportamento

### Saudação dinâmica por período

| Período | Horário | Ícone Material | Saudação |
|---------|---------|----------------|----------|
| Manhã | 5h–12h | `Icons.wb_sunny_rounded` | Bom dia! |
| Tarde | 12h–18h | `Icons.light_mode_rounded` | Boa tarde! |
| Noite | 18h–5h | `Icons.nightlight_round` | Boa noite! |

O ícone e o texto de saudação variam pelo período; as cores permanecem fixas no tema do app (`CoresApp.primaria`).

> [!note] Decisão de design
> A abordagem inicial usava cores dinâmicas por período (gradientes, accents e textos distintos). Foi descartada em favor do tema fixo — apenas ícone e saudação variam. Emojis foram substituídos por Material Icons por falha de renderização com `fontFamily` customizada.

### Indicador de progresso (hoje)

Card branco com anel circular (`CircularProgressIndicator`) mostrando:
- Percentual de conclusão centralizado no anel (`CoresApp.primaria`)
- Contador "X de Y concluídas"
- Mensagem motivacional adaptada ao percentual

| Percentual | Mensagem |
|------------|----------|
| Sem metas | Nenhuma meta para hoje |
| 0% | Vamos começar! |
| 1–49% | Bom progresso, continue! |
| 50–99% | Quase lá, não pare! |
| 100% | Dia completo! Parabéns! |

### Card de total semanal

Card compacto exibindo a soma de todas as metas dos 7 dias da semana atual.
Atualiza ao adicionar uma meta manual (incremento direto) e ao inicializar o app (recálculo completo).
Pluralização: "1 meta" / "N metas".

### Navegação — bottom navbar

`NavigationBar` (Material 3) com `IndexedStack` preservando o estado de cada aba.

| Índice | Label | Ícone | Destino |
|--------|-------|-------|---------|
| 0 | Home | `home_rounded` | `TelaInicialPage` |
| 1 | Metas | `task_alt_rounded` | `SemanaPage` |
| 2 | Configurações | `settings_rounded` | `ConfiguracoesPage` |

### Tela de configurações

Lista de opções estilizadas (`_ItemConfiguracao`): ícone em pill verde + título + subtítulo + chevron.
Ao tocar, abre a tela destino via `Navigator.push`.

| Opção | Destino |
|-------|---------|
| Metas recorrentes | `MetasRecorrentesPage` |

---

## Arquivos criados

### `lib/core/enums/periodo_dia.dart`

Enum `PeriodoDia`: `manha`, `tarde`, `noite`.
Função `periodoAtual()` determina o período por `DateTime.now().hour`.

### `lib/views/tela_inicial/tela_inicial_page.dart`

`TelaInicialPage` — StatefulWidget.

- `initState` chama `SemanaViewModel.inicializar()` via `postFrameCallback`
- Layout: header (saudação curta + "My Week" + sino) → cartão saudação verde → card total semana → card progresso hoje
- `_InfoPeriodo` — classe privada com `icone`, `saudacao` e `saudacaoCurta`
- `_cartaoSaudacao` — card verde com ícone do período, saudação, data por extenso e número do dia como watermark
- `_cardTotalSemana` — card branco compacto com ícone de calendário e contagem semanal

### `lib/views/tela_inicial/widgets/indicador_progresso_diario.dart`

`IndicadorProgressoDiario` — StatelessWidget.

Recebe `total` e `concluidas`. Usa `CoresApp.primaria` e `CoresApp.primariaSuave` fixos.
Layout horizontal: anel circular (88×88) à esquerda, stats à direita.

### `lib/views/navegacao/navegacao_page.dart`

`NavegacaoPage` — StatefulWidget. Shell da navegação principal.

- `IndexedStack` com as 3 páginas (estado preservado ao trocar aba)
- `NavigationBar` com `indicatorColor: CoresApp.primariaSuave`

### `lib/views/configuracoes/configuracoes_page.dart`

`ConfiguracoesPage` — StatelessWidget.

Lista de opções de configuração. Cada item é um `_ItemConfiguracao` (widget privado) com ícone em container arredondado, título, subtítulo e chevron. Navega via `Navigator.push`.

---

## Arquivos modificados

### `lib/core/utils/formatador_data.dart`

Adicionada `formatarDataExtenso(DateTime)` → ex.: `"Sexta, 09 de maio"`.
Usa `DiaSemana.nomeCompleto` e lista de meses em português, sem dependência de `intl`.

### `lib/viewmodels/semana_viewmodel.dart`

| Adição | Descrição |
|--------|-----------|
| `int _totalMetasDaSemana` | Campo interno com total da semana |
| `int get totalMetasDaSemana` | Exposição pública do total |
| `_carregarTotalDaSemana()` | Gera metas recorrentes para os 7 dias da semana atual e soma o total |
| `inicializar()` | Chama `_carregarTotalDaSemana()` após `selecionarDia()` |
| `adicionarMetaManual()` | Incrementa `_totalMetasDaSemana` diretamente ao adicionar |

### `lib/views/semana/semana_page.dart`

Removidos: método `_irParaMetasRecorrentes()`, bloco `actions` do AppBar e imports de `MetasRecorrentesPage`/`MetasRecorrentesViewModel` — navegação agora é responsabilidade do navbar.

### `lib/app/my_week_app.dart`

Home alterada de `SemanaPage` → `NavegacaoPage`.

---

## Estrutura de arquivos novos

```
lib/
├── core/
│   ├── enums/
│   │   └── periodo_dia.dart                        ← NOVO
│   └── utils/
│       └── formatador_data.dart                    ← MODIFICADO
├── viewmodels/
│   └── semana_viewmodel.dart                       ← MODIFICADO
└── views/
    ├── navegacao/
    │   └── navegacao_page.dart                     ← NOVO
    ├── configuracoes/
    │   └── configuracoes_page.dart                 ← NOVO
    └── tela_inicial/
        ├── tela_inicial_page.dart                  ← NOVO
        └── widgets/
            └── indicador_progresso_diario.dart     ← NOVO
```

---

## Resultado

> [!success] flutter analyze
> Nenhum erro encontrado.

O app abre na tela inicial com saudação dinâmica, card de total semanal e progresso do dia. A navegação principal acontece pelo bottom navbar com três abas. Configurações expõe uma lista de opções extensível — por ora com acesso às metas recorrentes.

---

## Próximos passos

- [ ] Tela de histórico e progresso semanal
- [ ] Persistência local com `sqflite` ou `shared_preferences`
- [ ] Integração com Supabase
- [ ] Notificações de lembrete
