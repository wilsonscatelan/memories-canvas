# MemoriesCanvas 

Diário visual interativo para registrar momentos, viagens e eventos marcantes. Projeto final da disciplina de Programação de Dispositivos Móveis I — IFMS.

## Funcionalidades

- Feed de memórias com layout moderno usando `SliverAppBar` e `SliverList`.
- Cadastro com seleção de foto da galeria, preview antes de salvar e validação de formulário.
- Detalhes com foto em destaque, descrição completa e data formatada.
- Exclusão com confirmação via `AlertDialog`, removendo o registro do JSON e o arquivo físico da imagem.
- Persistência manual via `jsonEncode`/`jsonDecode` em arquivo `memories.json` no diretório do app (sem SQLite ou SharedPreferences).

## Como rodar

```bash
flutter pub get
flutter run
```

## Conceitos aplicados

- `StatefulWidget` + `initState` para carga inicial dos dados.
- `Navigator.push` com retorno via `Navigator.pop(context, valor)`.
- Passagem de parâmetros via construtor (`DetailScreen(memory: memory)`).
- `SliverAppBar` com `FlexibleSpaceBar` e modo stretch.
- `FloatingActionButton`, `Card`, `SnackBar`, `AlertDialog`.
- Serialização manual: `jsonEncode` / `jsonDecode`.
- Manipulação de arquivos: `File.writeAsString`, `File.copy`, `File.delete`.
