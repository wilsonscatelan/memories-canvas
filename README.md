# MemoriesCanvas 

Diário visual interativo para registrar momentos, viagens e eventos marcantes. Projeto final da disciplina de Flutter — IFMS.

## Funcionalidades

- **Feed de memórias** com layout moderno usando `SliverAppBar` e `SliverList`
- **Cadastro** com seleção de foto da galeria, preview antes de salvar e validação de formulário
- **Detalhes** com foto em destaque, descrição completa e data formatada
- **Exclusão** com confirmação via `AlertDialog`, removendo o registro do JSON e o arquivo físico da imagem
- **Persistência manual** via `jsonEncode`/`jsonDecode` em arquivo `memories.json` no diretório do app (sem SQLite ou SharedPreferences)

## Estrutura de pastas

```
lib/
├── main.dart
├── models/
│   └── memory.dart          # Modelo com serialização JSON
├── screens/
│   ├── home_screen.dart     # Tela inicial (feed)
│   ├── add_memory_screen.dart  # Cadastro de memória
│   └── detail_screen.dart   # Detalhes e exclusão
├── utils/
│   ├── storage_service.dart # Leitura/escrita de arquivo e cópia de imagens
│   └── app_theme.dart       # Tema escuro personalizado
└── widgets/
    ├── memory_card.dart     # Card do feed
    └── empty_state.dart     # Estado vazio
```

## Dependências

| Pacote | Uso |
|---|---|
| `image_picker` | Acesso à galeria do dispositivo |
| `path_provider` | Caminho do diretório permanente do app |
| `intl` | Formatação de datas em pt_BR |

## Como rodar

```bash
flutter pub get
flutter run
```

## Conceitos aplicados

- `StatefulWidget` + `initState` para carga inicial dos dados
- `Navigator.push` com retorno via `Navigator.pop(context, valor)`
- Passagem de parâmetros via construtor (`DetailScreen(memory: memory)`)
- `SliverAppBar` com `FlexibleSpaceBar` e modo stretch
- `FloatingActionButton`, `Card`, `SnackBar`, `AlertDialog`
- Serialização manual: `jsonEncode` / `jsonDecode`
- Manipulação de arquivos: `File.writeAsString`, `File.copy`, `File.delete`
