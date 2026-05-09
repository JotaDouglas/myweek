---
título: Etapa 002 — Tela inicial com saudação dinâmica
data: 2026-05-09
status: concluída
tags:
  - myweek
  - flutter
  - etapa
---

# Etapa 002 — Tela inicial com saudação dinâmica

## Contexto

O app passava a abrir direto na tela de semana. Esta etapa cria uma `TelaInicialPage` que serve como home screen: saudação baseada no período do dia (manhã/tarde/noite), com identidade visual distinta para cada período, e um indicador circular de progresso das metas do dia.

---

## Comportamento

### Saudação dinâmica

| Período | Horário | Emoji | Saudação |
|---------|---------|-------|----------|
| Manhã | 5h–12h | ☀️ | Bom dia! |
| Tarde | 12h–18h | ⛅ | Boa tarde! |
| Noite | 18h–5h | 🌙 | Boa noite! |

Cada período tem um gradiente de fundo, cor de texto e accent distintos — determinados em tempo de execução via `periodoAtual()`.

### Indicador de progresso

Exibe um anel circular (`CircularProgressIndicator`) com:
- Percentual de conclusão centralizado no anel
- Contador "X de Y concluídas"
- Mensagem motivacional adaptada ao progresso

### Navegação

Botão "Ver metas do dia" → abre `SemanaPage` via `Navigator.push`.
Ao retornar, chama `inicializar()` no `SemanaViewModel` para recarregar os dados de hoje.

---

## Arquivos criados

### `lib/core/enums/periodo_dia.dart`

Enum `PeriodoDia` com três valores: `manha`, `tarde`, `noite`.
Função `periodoAtual()` retorna o período baseado em `DateTime.now().hour`.

### `lib/views/tela_inicial/tela_inicial_page.dart`

`TelaInicialPage` — StatefulWidget.

- `initState` chama `SemanaViewModel.inicializar()` via `postFrameCallback`
- `build` deriva o tema do período e calcula total/concluídas a partir de `vm.metasDoDia`
- `_TemaPeriodo` — classe privada que agrupa gradiente, corTexto, corAccent, emoji e saudação
- Fundo em gradiente full-screen sem AppBar, usando `SafeArea` + `Column` com `Spacer`

### `lib/views/tela_inicial/widgets/indicador_progresso_diario.dart`

`IndicadorProgressoDiario` — StatelessWidget.

Recebe `total`, `concluidas`, `corAccent` e `corTexto`.
Renderiza card translúcido com anel de progresso e mensagem motivacional.

---

## Arquivos modificados

### `lib/core/theme/cores_app.dart`

Adicionados 12 valores de cor para os três períodos:

| Constante | Valor | Uso |
|-----------|-------|-----|
| `fundoManha1` / `fundoManha2` | `#FFFBF2` / `#FFE5C0` | Gradiente manhã |
| `accentManha` | `#D4873A` | Accent âmbar |
| `textoManha` | `#3D2B1F` | Texto sobre fundo claro |
| `fundoTarde1` / `fundoTarde2` | `#FFF4EC` / `#FFD4A0` | Gradiente tarde |
| `accentTarde` | `#E07020` | Accent laranja-dourado |
| `textoTarde` | `#3E2010` | Texto sobre fundo quente |
| `fundoNoite1` / `fundoNoite2` | `#1C2540` / `#0D1420` | Gradiente noite |
| `accentNoite` | `#8B9FE8` | Accent índigo suave |
| `textoNoite` | `#E8ECF8` | Texto sobre fundo escuro |

### `lib/core/utils/formatador_data.dart`

Adicionada `formatarDataExtenso(DateTime)` → ex.: `"Sexta, 09 de maio"`.
Usa `DiaSemana.nomeCompleto` e lista de meses em português sem dependência de `intl`.

### `lib/app/my_week_app.dart`

Home alterada de `SemanaPage` para `TelaInicialPage`.

---

## Estrutura de arquivos novos

```
lib/
├── core/
│   └── enums/
│       └── periodo_dia.dart             ← NOVO
└── views/
    └── tela_inicial/
        ├── tela_inicial_page.dart       ← NOVO
        └── widgets/
            └── indicador_progresso_diario.dart  ← NOVO
```

---

## Resultado

> [!success] flutter analyze
> Nenhum erro encontrado.

A tela inicial exibe saudação, data por extenso e progresso das metas do dia. A identidade visual muda dinamicamente conforme o horário. Ao tocar em "Ver metas do dia", o usuário vai para `SemanaPage`; ao voltar, os dados de hoje são recarregados automaticamente.

---

## Próximos passos

- [ ] Tela de histórico e progresso semanal
- [ ] Persistência local com `sqflite` ou `shared_preferences`
- [ ] Integração com Supabase
- [ ] Notificações de lembrete
