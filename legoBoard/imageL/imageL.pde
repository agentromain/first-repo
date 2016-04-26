PImage img;
PImage result;
HScrollbar hs;
HScrollbar hs2;
float[][] kernel = {{1,4,7,4,1},
  {4,16,26,16,4},
  {7,26,41,26,7},
  {4,16,26,16,4},
  {1,4,7,4,1}
  };
float[][] kernel1 = { { 0, 0, 0 },
  { 0, 2, 0 },
  { 0, 0, 0 }};
  
void settings() {
  size(800, 600);
}
void setup() {
  img = loadImage("../board1.jpg");
  result = createImage(img.width, img.height, RGB);
  hs = new HScrollbar(0, 560, 800, 40);
  hs2 = new HScrollbar(0, 510, 800, 40);
  //noLoop(); // no interactive behaviour: draw() will be called only once.
}

void draw() {
  background(0, 0, 0);
  result.loadPixels();
  
  selectHue(img,hs.getPos(), hs2.getPos());
  result.updatePixels();
  image(sobel(convolute(result,kernel,3)), 0, 0);
   hs.update();
   hs.display();
   hs2.update();
   hs2.display();
   
}

void tBinary(PImage img1, float threshold, color c1, color c2) {
  println("b: " + brightness(img1.pixels[10]) + " t : " + threshold);
  for (int i = 0; i < img1.width * img1.height; ++i) {
    if (brightness(img1.pixels[i]) > threshold) {
      result.pixels[i] = c1;
    } else {
      result.pixels[i] = c2;
    }
  }
}

void thresholdBinary(PImage img, float ratio) {
  tBinary(img, 255.0*ratio, color(255, 255, 255), color(0, 0, 0));
}

void thresholdBinaryInvert(PImage img, float ratio) {
  tBinary(img, 255.0*ratio, color(0, 0, 0), color(255, 255, 255));
}

void toHue(PImage img) {
  for (int i = 0; i < img.width * img.height; ++i) {
    float h = hue(img.pixels[i]);
    result.pixels[i] = color(h, h, h);
  }
}

void selectHue(PImage img, float max, float min) {
  if (max < min) {
    float b = min;
    min = max;
    max = b;
  }
  color c = color(0, 0, 0);
  for (int i = 0; i < img.width * img.height; ++i) {
    float h = hue(img.pixels[i]);
    if (max*255 >= h && h >= min*255) {
      result.pixels[i] = img.pixels[i];
    } else {
      result.pixels[i] = c;
    }
  }
}

PImage convolute(PImage img1, float[][] kernel, int side) {
  PImage result = createImage(img.width, img.height, ALPHA);
  for (int i = 1; i < img1.height - 1; ++i) {
    for (int j = 1; j < img1.width - 1; ++j) {
      float sum = 0;
      float tot = 0;
      for (int k = 0; k < side; ++k) {
        for (int l = 0; l < side; ++l) {
          sum += kernel[k][l]*brightness(img1.pixels[(i - (side/2 - k))*img1.width + j - (side/2 - l)]);
          tot += kernel[k][l];
        }
      }
      result.pixels[i*img1.width + j] = color(sum/tot);
    }
  }
  return result;
}

PImage sobel(PImage img1) {
  float[][] hKernel = { { 0, 1, 0 }, 
    { 0, 0, 0 }, 
    { 0, -1, 0 } };
  float[][] vKernel = { { 0, 0, 0 }, 
    { 1, 0, -1 }, 
    { 0, 0, 0 } };
  // clear the image
  for (int i = 0; i < img1.width * img1.height; i++) {
    result.pixels[i] = color(0,0,0);
  }
  float max=0;
  float[] buffer = new float[img1.width * img1.height];
  PImage result = createImage(img.width, img.height, ALPHA);
  // *************************************
  // Implement here the double convolution
  // *************************************
  
  int side = 3;
  for (int i = 1; i < img1.height - 1; ++i) {
    for (int j = 1; j < img1.width - 1; ++j) {
      float vsum = 0;
      float hsum = 0;
      for (int k = 0; k < side; ++k) {
        for (int l = 0; l < side; ++l) {
          vsum += vKernel[k][l]*brightness(img1.pixels[(i - (side/2 - k))*img1.width + j - (side/2 - l)]);
          hsum += hKernel[k][l]*brightness(img1.pixels[(i - (side/2 - k))*img1.width + j - (side/2 - l)]);
        }
      }
      float b = brightness(img1.pixels[i*img1.width + j]);
      if(b > max ){max = b;}
      buffer[i*img1.width + j] = sqrt(vsum*vsum + hsum*hsum);
    }
  }
  
  for (int y = 2; y < img.height - 2; y++) { // Skip top and bottom edges
    for (int x = 2; x < img.width - 2; x++) { // Skip left and right
      if (buffer[y * img.width + x] > (int)(max * 0.3f)) { // 30% of the max
        result.pixels[y * img.width + x] = color(255, 255, 255);
      } else {
        result.pixels[y * img.width + x] = color(0, 0, 0);
      }
    }
  }
  return result;
}    

//==============================
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