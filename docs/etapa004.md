---
título: Etapa 004 — Scroll automático de semana e modo de planejamento
data: 2026-05-10
status: concluída
tags:
  - myweek
  - flutter
  - etapa
---

# Etapa 004 — Scroll automático de semana e modo de planejamento

## Contexto

Dois conjuntos de melhorias nesta etapa. O primeiro é uma melhoria de usabilidade no seletor de dias: quando o dia atual já passou da metade da semana, o scroll horizontal começa posicionado no final para que sábado fique visível. O segundo é uma funcionalidade nova — o modo de planejamento da semana — acessado pela tela Home e que permite ao usuário organizar metas em todos os dias da semana de uma vez.

---

## Funcionalidades adicionadas

### Scroll automático no seletor de dias

Quando o app é aberto em um dia da segunda metade da semana (quinta, sexta ou sábado), o `SeletorDiasSemana` posiciona automaticamente o scroll no final, deixando o sábado visível sem interação manual.

**Lógica de posição:**

```dart
// weekday % 7 → 0=Dom, 1=Seg, 2=Ter, 3=Qua, 4=Qui, 5=Sex, 6=Sáb
final posicaoNaSemana = hoje.weekday % 7;
if (posicaoNaSemana > 3) {
  _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
}
```

| Dia atual | `weekday % 7` | Comportamento |
|-----------|--------------|---------------|
| Dom–Qua   | 0–3          | Scroll no início (domingo visível) |
| Qui–Sáb   | 4–6          | **Scroll no final (sábado visível)** |

A chamada usa `jumpTo` (instantâneo) via `addPostFrameCallback`, garantindo que o layout já esteja calculado antes do salto.

---

### Modo de planejamento da semana

Nova tela que exibe os sete dias da semana atual, um por vez, em cards navegáveis. Permite adicionar, editar e excluir metas em qualquer dia sem precisar navegar individualmente pela tela de metas.

#### Entrada — row de ações na tela Home

Substituiu o card quadrado único por uma **row de quatro slots iguais** (`Expanded` + `AspectRatio 1:1`). O primeiro slot é o botão de planejamento (foguete); os outros três estão vazios e reservados para funcionalidades futuras.

```
┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐
│  🚀  │ │      │ │      │ │      │
│Plane-│ │      │ │      │ │      │
│ jar  │ │      │ │      │ │      │
└──────┘ └──────┘ └──────┘ └──────┘
  ativo   vazio    vazio    vazio
```

- Botão ativo: fundo `primariaSuave`, ícone 28px, label 12px bold
- Slots vazios: borda `divisor`, sem conteúdo

#### Layout da tela — `PlanejamentoSemanaPage`

```
AppBar  [←]  🚀 Planejar semana
─────────────────────────────────
SeletorDias  [Dom][Seg][Ter][Qua][Qui][Sex][Sáb]
─────────────────────────────────
PageView (swipeable)
  ┌──────────────────────────────┐
  │ Segunda          12 mai      │
  │ ──────────────────────────── │
  │ ● Meta A               ✏️ 🗑️ │
  │ ● Meta B               ✏️ 🗑️ │
  └──────────────────────────────┘

  [ + Nova meta ]   ← botão abaixo do card
```

O seletor de dias e o `PageView` são sincronizados bidirecionalmente:
- Toque em um chip → `PageController.animateToPage`
- Swipe na página → `setState` + scroll do seletor para o chip ativo

A tela abre já no chip do dia atual (`hoje.weekday % 7`).

#### Bottom sheet de meta — `_FormularioPlanejamento`

Mesmo estilo visual do `FormularioMetaDiaria` da tela de metas, mas **sem o seletor de data** (a data é determinada pelo dia do card). Reutilizável para adicionar e editar via parâmetros:

| Parâmetro | Tipo | Padrão | Descrição |
|-----------|------|--------|-----------|
| `dia` | `DateTime` | obrigatório | Dia ao qual a meta pertence |
| `onSalvar` | `void Function(String)` | obrigatório | Callback com o título |
| `tituloInicial` | `String?` | `null` | Pré-preenche o campo (modo edição) |
| `labelBotao` | `String` | `'Adicionar'` | Texto do botão principal |

```dart
// Adicionar
_FormularioPlanejamento(dia: dia, onSalvar: (t) => vm.adicionarMetaManual(t, data: dia))

// Editar
_FormularioPlanejamento(
  dia: meta.data,
  tituloInicial: meta.titulo,
  labelBotao: 'Salvar',
  onSalvar: (t) => vm.atualizarMetaDiaria(meta, t),
)
```

#### Ações por meta

Cada item da lista exibe dois ícones no trailing:

| Ícone | Ação |
|-------|------|
| `Icons.edit_outlined` | Abre o mesmo bottom sheet com `tituloInicial` preenchido |
| `Icons.delete_outline_rounded` | Remove imediatamente, sincroniza `_metasPorDia` |

---

## Arquivos criados

### `lib/views/planejamento_semana/planejamento_semana_page.dart`

Widgets definidos neste arquivo:

| Widget | Tipo | Responsabilidade |
|--------|------|-----------------|
| `PlanejamentoSemanaPage` | `StatefulWidget` | Page principal; gerencia `PageController`, seletor e estado |
| `_FormularioPlanejamento` | `StatefulWidget` | Bottom sheet de adição/edição sem seletor de data |
| `_SeletorDias` | `StatelessWidget` | Linha horizontal de chips de dia |
| `_ChipDia` | `StatelessWidget` | Chip individual (ativo / hoje / padrão) |
| `_CardDia` | `StatelessWidget` | Card do dia com header, lista de metas e estado vazio |
| `_ItemMeta` | `StatelessWidget` | Linha de meta com ponto, título, editar e excluir |

---

## Arquivos modificados

### `lib/views/semana/widgets/seletor_dias_semana.dart`

- Convertido de `StatelessWidget` para `StatefulWidget`
- `ScrollController _scrollController` adicionado com `dispose` adequado
- `initState` → `addPostFrameCallback` → `_ajustarScrollInicial()`
- `ListView` recebe `controller: _scrollController`

### `lib/viewmodels/semana_viewmodel.dart`

| Adição / alteração | Descrição |
|--------------------|-----------|
| `_metasPorDia` | `Map<String, List<MetaDiaria>>` indexado por `'yyyy-MM-dd'` |
| `metasPorDia` | Getter público (unmodifiable) |
| `_chaveDia(DateTime)` | Helper que formata a chave do mapa |
| `carregarSemanaCompleta()` | Gera recorrentes e carrega metas dos 7 dias da semana atual |
| `atualizarMetaDiaria(meta, novoTitulo)` | Substitui via `salvarMetaDiaria` (ConflictAlgorithm.replace); atualiza `_metasPorDia` e `_metasDoDia` conforme necessário |
| `removerMetaDiaria(id, {DateTime? data})` | Parâmetro `data` adicionado; quando fornecido, recarrega o dia em `_metasPorDia` |
| `adicionarMetaManual` | Atualiza `_metasPorDia[chave]` se a chave já estiver carregada |

### `lib/views/tela_inicial/tela_inicial_page.dart`

- `_cardPlanejamento` substituído por `_rowAcoes`
- Adicionados widgets `_BotaoAcao` e `_BotaoAcaoVazio`
- Import de `PlanejamentoSemanaPage` adicionado

---

## Estrutura de arquivos novos

```
lib/
└── views/
    └── planejamento_semana/
        └── planejamento_semana_page.dart    ← NOVO
```

---

## Resultado

> [!success] flutter analyze
> Nenhum erro encontrado.

O app agora exibe automaticamente o final da semana quando o dia corrente é quinta, sexta ou sábado. A tela Home tem uma row de ações rápidas preparada para quatro botões, sendo o primeiro o acesso ao planejamento semanal. O modo de planejamento permite visualizar, adicionar, editar e excluir metas para cada dia da semana em uma interface dedicada e fluida.

---

## Próximos passos

- [ ] Adicionar os demais botões à row de ações da Home
- [ ] Tela de histórico e progresso semanal
- [ ] Integração com Supabase
- [ ] Notificações de lembrete
