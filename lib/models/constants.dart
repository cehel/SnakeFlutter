const double BOARD_WIDTH = 360.0;
const double BOARD_HEIGHT = 600.0;
const double GRID_X = BOARD_WIDTH/SNAKE_SIZE;
const double GRID_Y = BOARD_HEIGHT/SNAKE_SIZE;
const double SNAKE_SIZE = 20.0;
const double APPLE_SIZE = 20.0;
enum RICHTUNG { LINKS, OBEN, RECHTS, UNTEN }
enum GAMESTATE { HOMEPAGE, INIT, RUNNING, VICTORY, DIED }
