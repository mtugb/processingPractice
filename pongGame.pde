Ball ball;
Bar leftBar;
Bar rightBar;
int FRAME_RATE = 60;
int phase = 0;
float[] speedForPhases = {
    1, 1.2, 1.5, 2, 3
};
boolean prepared = false;
boolean playing = true;

void setup() {
    size(800, 800);
    int[] vectorListX = {1, 1, -1, -1};
    int[] vectorListY = {1, -1, 1, -1};
    int index = floor(random(4));
    ball = new Ball(400, 400, vectorListX[index], vectorListY[index]);
    leftBar = new Bar(0);
    rightBar = new Bar(1);
    frameRate(FRAME_RATE);
    
    prepared = true;
}

int tick = 0;
void draw() {
    if (prepared && playing && tick > 60 * 5) {
        clearCanvas();
        for (int i = speedForPhases.length - 1;i >-  1;i--) {//でかい順
            if (tick > i * 60 * 5) {
                fill(0);
                textAlign(LEFT);
                textSize(30);
                text("Phase: " + (i + 1) + " (x" + speedForPhases[i] + ")", 20, 50);
                ball.speed = 15 * speedForPhases[i];
                break;
            }
        }
        if (ball.x < 0 + 10) {
            if (abs(ball.y - leftBar.y) < 40)
                ball.reflectX();
            else
                gameOver(0);
        } else if (ball.x > 800 - 10) {
            if (abs(ball.y - rightBar.y) < 40)
                ball.reflectX();
            else
                gameOver(1);
        } else if (ball.y < 0 || ball.y > 800) {
            ball.reflectY();
        }
        ball.update();
        leftBar.update();
        rightBar.update();
    }
    if (tick < 60 * 5) {
        clearCanvas();
        fill(0);
        textAlign(CENTER);
        textSize(30);
        text("Start in " + floor(5 - tick / 60), 400, 400);
    }
    tick++;
}

class Ball {
    public float x;
    public float y;
    public float vectorX;
    public float vectorY;
    public float speed;
    private int SPEED_ADJUSTMENT = 10;
    
    private Ball(float x, float y, float vectorX, float vectorY) {
        this.x = x;
        this.y = y;
        this.vectorX = vectorX;
        this.vectorY = vectorY;
        this.speed = 15;
        println("Ball class set up");
    }
    
    public void reflectX() {
        this.vectorX *= -1;
    }
    
    public void reflectY() {
        this.vectorY *= -1;
    }
    
    public void update() {
        float length = sqrt(vectorX * vectorX + vectorY * vectorY);
        this.x += this.vectorX / length / FRAME_RATE * this.speed * this.SPEED_ADJUSTMENT;
        this.y += this.vectorY / length / FRAME_RATE * this.speed * this.SPEED_ADJUSTMENT;
        // println(this.x);
        fill(0);
        ellipse(this.x, this.y, 10, 10);
    }
}

class Bar {
    public float y = 400;
    private int type;//0:left, 1:right
    private Bar(int type) {
        this.type = type;
    }
    public void update() {
        switch(this.type) {
            case 0:
                this.y = mouseY;
                break;
            case 1:
                if (keyPressed) {
                    if (keyCode == UP) {
                        if (this.y - 30 > 0)
                            this.y -= 3;
                    }
                    if (keyCode == DOWN) {
                        if (this.y + 30 < 800)
                            this.y += 3;
                    }
                }
                break;
        }
        fill(0);
        // line(this.type * 790, this.y - 20, this.type * 800, this.y + 20);
        int[] startingPoint = {0, 790};
        rect(startingPoint[this.type], this.y - 40, 10, 80);
    }
}

void clearCanvas() {
    fill(225);
    rect(0, 0, width, height);
}

void gameOver(int loser) {
    playing = false;
    String[] name = {"Left", "Right"};
    clearCanvas();
    fill(0);
    textAlign(CENTER);
    text(name[1 - loser] + " has won", 400, 400);
}
