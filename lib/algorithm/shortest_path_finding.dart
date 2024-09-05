import 'dart:collection';

//Модифікуємо початковий масив рядків для зручності розрахунків

//значення елементу в масиві М[row][column]:
//0: початкова комірка
//-1 : відстань до комірки ще не прорахована
//-2 : комірка заблокована
//-3 : комірка не існує

List<List<int>> createPlayfield(List<String> task) {
  List<List<int>> result = [];
  for (int i = 0; i < task.length; i++) {
    result.add([]);
    for (int j = 0; j < task[i].length; j++) {
      if (task[i][j] == '.') {
        result[i].add(-1);
      } else if (task[i][j] == 'X') {
        result[i].add(-2);
      }
    }
  }
  return result;
}

//Перевіряємо чи існує комірка з заданими початковими координатами row, col в системі координат ігрового поля
int isCellExist(List<List<int>> initialMatr, int row, int col) {
  if (col < 0 ||
      col > initialMatr.length - 1 ||
      row < 0 ||
      row > initialMatr[0].length - 1) return -3;
  return initialMatr[row][col];
}

List<List<int>> bfs(List<List<int>> matr, List<int> startPos) {
  //Перевіряємо чи існує комірка з заданими початковими координатами startPos[0], startPos[1] в системі координат ігрового поля
  if (isCellExist(matr, startPos[0], startPos[1]) == -2 ||
      isCellExist(matr, startPos[0], startPos[1]) == -3) return [];
  //Задаємо відстань до початкової комірки рівною 0, створюємо чергу з координатами комірок, додаємо стартове положення в чергу
  matr[startPos[0]][startPos[1]] = 0;
  final cellsQueue = Queue<List<int>>();
  cellsQueue.add(startPos);
  //Дістаємо першу комірку з черги і вираховуємо відстань від неї до усіх сусідів з кроком 1, після чого додаємо кожну сусудню комірку в чергу.
  //Повторюємо для кожної комірки з черги поки черга не пуста
  while (cellsQueue.isNotEmpty) {
    List<int> currentCell = cellsQueue.removeFirst();
    int currentRow = currentCell[0];
    int currentCol = currentCell[1];
    //Вираховуємо відстань від поточної комірки до її найближчих сусідів
    //По діагоналі угору-наліво
    if (isCellExist(matr, currentRow - 1, currentCol - 1) == -1) {
      matr[currentRow - 1][currentCol - 1] = matr[currentRow][currentCol] + 1;
      cellsQueue.add([currentRow - 1, currentCol - 1]);
    }
    //По діагоналі угору-направо
    if (isCellExist(matr, currentRow - 1, currentCol + 1) == -1) {
      matr[currentRow - 1][currentCol + 1] = matr[currentRow][currentCol] + 1;
      cellsQueue.add([currentRow - 1, currentCol + 1]);
    }
    //По діагоналі вниз-наліво
    if (isCellExist(matr, currentRow + 1, currentCol - 1) == -1) {
      matr[currentRow + 1][currentCol - 1] = matr[currentRow][currentCol] + 1;
      cellsQueue.add([currentRow + 1, currentCol - 1]);
    }
    //По діагоналі вниз-направо
    if (isCellExist(matr, currentRow + 1, currentCol + 1) == -1) {
      matr[currentRow + 1][currentCol + 1] = matr[currentRow][currentCol] + 1;
      cellsQueue.add([currentRow + 1, currentCol + 1]);
    }
    //Угору
    if (isCellExist(matr, currentRow - 1, currentCol) == -1) {
      matr[currentRow - 1][currentCol] = matr[currentRow][currentCol] + 1;
      cellsQueue.add([currentRow - 1, currentCol]);
    }
    //Вниз
    if (isCellExist(matr, currentRow + 1, currentCol) == -1) {
      matr[currentRow + 1][currentCol] = matr[currentRow][currentCol] + 1;
      cellsQueue.add([currentRow + 1, currentCol]);
    }
    //Наліво
    if (isCellExist(matr, currentRow, currentCol - 1) == -1) {
      matr[currentRow][currentCol - 1] = matr[currentRow][currentCol] + 1;
      cellsQueue.add([currentRow, currentCol - 1]);
    }
    //Направо
    if (isCellExist(matr, currentRow, currentCol + 1) == -1) {
      matr[currentRow][currentCol + 1] = matr[currentRow][currentCol] + 1;
      cellsQueue.add([currentRow, currentCol + 1]);
    }
  }
  return matr;
}

List<List<int>> getPath(
  List<String> initialMatr,
  List<int> startPos,
  List<int> endPos,
) {
  //Створюємо ігрове поле з заміною символів "." та "Х" згідно кодуванню вище
  final playField = createPlayfield(initialMatr);
  //Поетапно прораховуємо відстані від початкової комірки до кожної наступної
  final fieldToExplore = bfs(playField, startPos);

  int startRow = startPos[0];
  int startCol = startPos[1];
  int currentRow = endPos[0];
  int currentCol = endPos[1];

  //ЯКЩО:
  //- неправильно задані координати кінцевої точки (виходять за межі ігрового поля)
  //- координати кінцевої точки співпадають з заблоковоною коміркою
  //- комірка виявилась недоступною для досягнення після прорахунку відстаней
  //Завершуємо побудову шляху і повертаємо пустий масив
  if (fieldToExplore[currentRow][currentCol] < 0) return [];

  //В іншому випадку додаємо кінцеву точку в масив зі збереженими комірками шляху
  List<List<int>> path = [endPos];

  //Починаючи від кінцевої комірки шукаємо найближчу комірку з мінімальною відстанню до початкової. Пріорітетно перевіряємо діагональні комірки.
  //Повторюємо цикл допоки координати поточної та початкової комірки не стануть рівними
  while (currentRow != startRow || currentCol != startCol) {
    //Надалі усі пошуки наступної комірки з найкоротшого шляху будуються одинаковим способом з поправкою на напрямок руху:
    //1. Перевіряємо чи існує та досяжна сусідня з поточною комірка
    //2. Перевіряємо чи дорівнює відстань сусудньої комірки відстані поточної мінус один до початкової комірки
    //Якщо умови виконуються додаємо цю комірку до масиву з координатами коміркок з найкоротшого шляху
    //Координати цієї комірки стають поточними і повторюємо перевірки

    //По діагоналі угору-наліво
    if (isCellExist(playField, currentRow - 1, currentCol - 1) ==
        fieldToExplore[currentRow][currentCol] - 1) {
      path.add([currentRow - 1, currentCol - 1]);
      currentRow = currentRow - 1;
      currentCol = currentCol - 1;
    }
    //По діагоналі угору-направо
    else if (isCellExist(playField, currentRow - 1, currentCol + 1) ==
        fieldToExplore[currentRow][currentCol] - 1) {
      path.add([currentRow - 1, currentCol + 1]);
      currentRow = currentRow - 1;
      currentCol = currentCol + 1;
    }
    //По діагоналі вниз-наліво
    else if (isCellExist(playField, currentRow + 1, currentCol - 1) ==
        fieldToExplore[currentRow][currentCol] - 1) {
      path.add([currentRow + 1, currentCol - 1]);
      currentRow = currentRow + 1;
      currentCol = currentCol - 1;
    }
    //По діагоналі вниз-направо
    else if (isCellExist(playField, currentRow + 1, currentCol + 1) ==
        fieldToExplore[currentRow][currentCol] - 1) {
      path.add([currentRow + 1, currentCol + 1]);
      currentRow = currentRow + 1;
      currentCol = currentCol + 1;
    }
    //Угору
    else if (isCellExist(playField, currentRow - 1, currentCol) ==
        fieldToExplore[currentRow][currentCol] - 1) {
      path.add([currentRow - 1, currentCol]);
      currentRow = currentRow - 1;
    }
    //Вниз
    else if (isCellExist(playField, currentRow + 1, currentCol) ==
        fieldToExplore[currentRow][currentCol] - 1) {
      path.add([currentRow + 1, currentCol]);
      currentRow = currentRow + 1;
    }
    //Наліво
    else if (isCellExist(playField, currentRow, currentCol - 1) ==
        fieldToExplore[currentRow][currentCol] - 1) {
      path.add([currentRow, currentCol - 1]);
      currentCol = currentCol - 1;
    }
    //Направо
    else if (isCellExist(playField, currentRow, currentCol + 1) ==
        fieldToExplore[currentRow][currentCol] - 1) {
      path.add([currentRow, currentCol + 1]);
      currentCol = currentCol + 1;
    }
  }
  final reversedPath = path.reversed.toList();
  return reversedPath;
}

String pathDetails(List<List<int>> path) {
  String result = '';
  for (int i = 0; i < path.length; i++) {
    result += '(${path[i][0]},${path[i][1]})';
    if (i < path.length - 1) {
      result += '->';
    }
  }
  return result;
}
