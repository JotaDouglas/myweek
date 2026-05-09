---
título: Etapa 003 — Exclusão de metas, dialog padrão, seleção de data e navegação por calendário
data: 2026-05-09
status: concluída
tags:
  - myweek
  - flutter
  - etapa
---

# Etapa 003 — Exclusão de metas, dialog padrão, seleção de data e navegação por calendário

## Contexto

Evolução da tela de metas diárias. Esta etapa adiciona exclusão de metas diárias, cria um componente de dialog reutilizável para o app, redesenha o card de meta com o indicador de conclusão à esquerda, permite definir a data de uma meta ao criá-la e adiciona navegação livre por qualquer dia do calendário.

---

## Funcionalidades adicionadas

### Exclusão de meta diária

Ícone de lixeira (`Icons.delete_outline`) no trailing do `CardMetaDiaria`. Ao tocar, exibe o `DialogoApp` de confirmação. Ao confirmar, a meta é removida do banco e da lista em memória, e o contador semanal é decrementado.

### Dialog padrão do app — `DialogoApp`

Componente centralizado que substitui o `AlertDialog` genérico do Flutter. Usado em todo o app para confirmações destrutivas ou neutras.

**Anatomia:**

```
┌─────────────────────────────┐
│                             │
│        [  ícone  ]          │  ← círculo colorido, opcional
│                             │
│         Título              │  ← bold, centralizado
│      Mensagem aqui          │  ← textoSecundario, centralizado
│                             │
├─────────────┬───────────────┤
│   Cancelar  │   Confirmar   │  ← divididos por linha vertical
└─────────────┴───────────────┘
```

| Prop | Tipo | Descrição |
|------|------|-----------|
| `titulo` | `String` | Título em negrito |
| `mensagem` | `String` | Corpo da mensagem |
| `labelConfirmar` | `String` | Padrão: `"Confirmar"` |
| `labelCancelar` | `String` | Padrão: `"Cancelar"` |
| `destrutivo` | `bool` | Confirmar em vermelho (`0xFFD94F4F`), ícone com fundo avermelhado |
| `icone` | `IconData?` | Ícone exibido no topo; fundo verde suave ou vermelho suave |

**Helper estático:**
```dart
final confirmar = await DialogoApp.mostrar(
  context,
  titulo: 'Remover meta',
  mensagem: 'Deseja remover "..."?',
  destrutivo: true,
  icone: Icons.delete_outline,
);
```
Retorna `Future<bool>` — `true` se o usuário confirmou.

### Redesign do `CardMetaDiaria` — check à esquerda

O `Checkbox` nativo foi substituído por um círculo animado no `leading` do `ListTile`.

| Estado | Visual |
|--------|--------|
| Pendente | Círculo vazado, borda cinza (`1.5px`), 20×20 |
| Concluída | Círculo preenchido `CoresApp.primaria`, ícone `check` branco (`size: 12`) |

Toque no círculo → alterna conclusão. Transição via `AnimatedContainer` (200ms).
Texto riscado (`TextDecoration.lineThrough`) e cor `textoSecundario` quando concluída.

### Seleção de data ao criar meta

O `FormularioMetaDiaria` (bottom sheet) exibe um campo de data logo abaixo do campo de texto.

- Pré-selecionado com o dia atualmente selecionado na tela
- Toque abre `showDatePicker` com tema `CoresApp.primaria`
- Exibe a data por extenso via `formatarDataExtenso()` com ícone de calendário
- Ao salvar, a meta é criada para a data escolhida (não necessariamente o dia visível)
- Se a data escolhida for diferente do dia selecionado, a lista não é recarregada (evita exibir meta no dia errado)

### Semana começa no domingo

Cálculo de início de semana alterado de segunda-feira para domingo.

```dart
// antes
final inicio = hoje.subtract(Duration(days: hoje.weekday - 1));

// depois  
final inicio = hoje.subtract(Duration(days: hoje.weekday % 7));
```

`DateTime.weekday` retorna 7 para domingo; `7 % 7 = 0` → subtrai zero dias → domingo permanece. Segunda = 1 → subtrai 1 → domingo anterior. Sábado = 6 → subtrai 6 → domingo anterior.

Aplicado em dois lugares: `SeletorDiasSemana` e `SemanaViewModel._carregarTotalDaSemana`.

### Botão de calendário na AppBar — navegação livre

Ícone `Icons.calendar_month_outlined` no `actions` do AppBar da `SemanaPage`. Ao tocar:

1. Abre `showDatePicker` com tema do app, centralizado no dia selecionado
2. Ao escolher uma data, chama `viewModel.selecionarDia(data)`
3. O `SeletorDiasSemana` recalcula a semana com base no **dia selecionado** (e não mais em `DateTime.now()`), navegando automaticamente para a semana da data escolhida

> [!note] Decisão de design
> O seletor passou a usar `viewModel.diaSelecionado` como referência da semana exibida. `DateTime.now()` continua sendo usado apenas para marcar o dia atual com destaque visual.

---

## Arquivos criados

### `lib/core/widgets/dialogo_app.dart`

`DialogoApp` — StatelessWidget. Dialog com borda arredondada (24px), sombra suave, ícone opcional, dois botões separados por divisor. `_BotaoDialogo` widget privado para cada botão. Helper estático `mostrar()`.

---

## Arquivos modificados

### `lib/data/repositories/meta_repository.dart`

Adicionado `removerMetaDiaria(String id)` à interface abstrata.

### `lib/data/repositories/meta_repository_sqlite.dart`

Implementação: `DELETE FROM metas_diarias WHERE id = ?`.

### `lib/data/repositories/meta_repository_memoria.dart`

Implementação: `_metasDiarias.removeWhere((m) => m.id == id)`.

### `lib/viewmodels/semana_viewmodel.dart`

| Alteração | Descrição |
|-----------|-----------|
| `adicionarMetaManual(titulo, {DateTime? data})` | Aceita data opcional; recarrega lista só se a data coincidir com o dia selecionado |
| `removerMetaDiaria(String id)` | Remove do repositório, da lista em memória e decrementa contador semanal |
| `_carregarTotalDaSemana()` | Início de semana corrigido para domingo |

### `lib/views/semana/widgets/card_meta_diaria.dart`

- `Checkbox` substituído por círculo animado no `leading`
- Lixeira no `trailing` abre `DialogoApp` destrutivo
- Tamanho do círculo: 20×20, borda 1.5px, ícone check size 12

### `lib/views/semana/widgets/formulario_meta_diaria.dart`

Campo de data adicionado entre o `TextField` e o botão de salvar. Usa `showDatePicker` com tema personalizado.

### `lib/views/semana/semana_page.dart`

- `_abrirCalendario()` — método que abre `showDatePicker` e chama `selecionarDia`
- `actions` no AppBar com `IconButton` de calendário

### `lib/views/semana/widgets/seletor_dias_semana.dart`

- `_obterDiasDaSemanaAtual(hoje)` renomeado para `_obterDiasDaSemana(referencia)`
- Referência de cálculo trocada de `DateTime.now()` para `viewModel.diaSelecionado`

### `lib/views/metas_recorrentes/widgets/card_meta_recorrente.dart`

`_confirmarRemocao` migrado do `AlertDialog` nativo para `DialogoApp.mostrar()`.

---

## Estrutura de arquivos novos

```
lib/
└── core/
    └── widgets/
        └── dialogo_app.dart    ← NOVO
```

---

## Resultado

> [!success] flutter analyze
> Nenhum erro encontrado.

O app permite excluir metas diárias com confirmação visual padronizada, criar metas para qualquer dia da semana, e navegar livremente por qualquer mês via botão de calendário na AppBar. A semana agora começa no domingo.

---

## Próximos passos

- [ ] Tela de histórico e progresso semanal
- [ ] Integração com Supabase
- [ ] Notificações de lembrete
