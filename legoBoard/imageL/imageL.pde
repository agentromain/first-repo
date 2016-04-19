PImage img;
PImage result;
HScrollbar hs;
HScrollbar hs2;

void settings() {
  size(800, 600);
}
void setup() {
  img = loadImage("../board1.jpg");
  hs = new HScrollbar(0, 560, 800, 40);
  hs2 = new HScrollbar(0, 510, 800, 40);
  
  //noLoop(); // no interactive behaviour: draw() will be called only once.
}

void draw() {
  background(0,0,0);
  image(img, 0, 0);
  hs.update();
  hs.display();
  hs2.update();
  hs2.display();
  thresholdBinary(img, hs.getPos());
}

void tBinary(PImage img, float threshold, color c1, color c2) {
  img.loadPixels();
  for (int i = 0; i < img.width * img.height; ++i) {
    if (brightness(img.pixels[i]) > threshold) {
      img.pixels[i] = c1;
    } else {
      img.pixels[i] = c2;
    }
  }
  img.updatePixels();
}

void thresholdBinary(PImage img, float ratio) {
  tBinary(img, 256*ratio, color(255, 255, 255), color(0, 0, 0));
}

void thresholdBinaryInvert(PImage img) {
  tBinary(img, 128, color(0, 0, 0), color(255, 255, 255));
}

PImage toHue(PImage img){
  PImage result = createImage(img.width, img.height, RGB);
  for (int i = 0; i < img.width * img.height; ++i) {
    float h = hue(img.pixels[i]);
    result.pixels[i] = color(h,h,h);
  }
  return result;
}

PImage selectHue(PImage img, float max, float min){
  
  if(max < min){
    float b = min;
    min = max;
    max = b;
  }
  
  PImage result = createImage(img.width, img.height, RGB);
  color c = color(0, 0, 0);
  for (int i = 0; i < img.width * img.height; ++i) {
    float h = hue(img.pixels[i]);
    if(max*255 > h && h > min*255){
      result.pixels[i] = img.pixels[i];
    }else{
      result.pixels[i] = c;
    }

  }
  return result;
}

class HScrollbar {
  float barWidth; //Bar’s width in pixels
  float barHeight; //Bar’s height in pixels
  float xPosition; //Bar’s x position in pixels
  float yPosition; //Bar’s y position in pixels
  float sliderPosition, newSliderPosition; //Position of slider
  float sliderPositionMin, sliderPositionMax; //Max and min values of slider
  boolean mouseOver; //Is the mouse over the slider?
  boolean locked; //Is the mouse clicking and dragging the slider now?
  /**
   * @brief Creates a new horizontal scrollbar
   *
   * @param x The x position of the top left corner of the bar in pixels
   * @param y The y position of the top left corner of the bar in pixels
   * @param w The width of the bar in pixels
   * @param h The height of the bar in pixels
   */
  HScrollbar (float x, float y, float w, float h) {
    barWidth = w;
    barHeight = h;
    xPosition = x;
    yPosition = y;
    sliderPosition = xPosition + barWidth/2 - barHeight/2;
    newSliderPosition = sliderPosition;
    sliderPositionMin = xPosition;
    sliderPositionMax = xPosition + barWidth - barHeight;
  }
  /**
   * @brief Updates the state of the scrollbar according to the mouse movement
   */
  void update() {
    if (isMouseOver()) {
      mouseOver = true;
    } else {
      mouseOver = false;
    }
    if (mousePressed && mouseOver) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newSliderPosition = constrain(mouseX - barHeight/2, sliderPositionMin, sliderPositionMax);
    }
    if (abs(newSliderPosition - sliderPosition) > 1) {
      sliderPosition = sliderPosition + (newSliderPosition - sliderPosition);
    }
  }
  /**
   * @brief Clamps the value into the interval
   *
   * @param val The value to be clamped
   * @param minVal Smallest value possible
   * @param maxVal Largest value possible
   *
   * @return val clamped into the interval [minVal, maxVal]
   */
  float constrain(float val, float minVal, float maxVal) {
    return min(max(val, minVal), maxVal);
  }
  /**
   * @brief Gets whether the mouse is hovering the scrollbar
   *
   * @return Whether the mouse is hovering the scrollbar
   */
  boolean isMouseOver() {
    if (mouseX > xPosition && mouseX < xPosition+barWidth &&
      mouseY > yPosition && mouseY < yPosition+barHeight) {
      return true;
    } else {
      return false;
    }
  }
  /**
   * @brief Draws the scrollbar in its current state
   */
  void display() {
    noStroke();
    fill(204);
    rect(xPosition, yPosition, barWidth, barHeight);
    if (mouseOver || locked) {
      fill(0, 0, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(sliderPosition, yPosition, barHeight, barHeight);
  }
  /**
   * @brief Gets the slider position
   *
   * @return The slider position in the interval [0,1]
   * corresponding to [leftmost position, rightmost position]
   */
  float getPos() {
    return (sliderPosition - xPosition)/(barWidth - barHeight);
  }
}