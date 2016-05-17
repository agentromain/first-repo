import processing.video.*;
Capture cam;
PImage img;
PImage result;
float[][] kernel = {{1, 4, 7, 4, 1}, 
  {4, 16, 26, 16, 4}, 
  {7, 26, 41, 26, 7}, 
  {4, 16, 26, 16, 4}, 
  {1, 4, 7, 4, 1}
};

float[][] kernel1 = {{1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, 
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, 
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, 
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, 
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
};

void settings() {
  size(800, 600);
}
void setup() {
  img = loadImage("../board1.jpg");
  /*String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    cam = new Capture(this, cameras[3]);
    cam.start();
  }*/

  noLoop(); // no interactive behaviour: draw() will be called only once.
}

void draw() {
  background(0, 0, 0);
  /*if (cam.available() == true) {
    cam.read();
  }*/

  //img = cam.get();
  result = createImage(img.width, img.height, RGB);
  result.loadPixels();
  selectHue(selectBrightness(img, 0, 124), 116, 136);
  result.updatePixels();
  //image(result, 0, 0);
  PImage im = sobel(selectBrightness(convolute(result, kernel, 5), 0, 124));
  image(im, 0, 0);
  getIntersections(hough(im, 6));
  
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

PImage selectBrightness(PImage image, float Min, float Max) {
  PImage result = createImage(img.width, img.height, RGB);
  for (int i = 0; i < image.width * image.height; ++i) {
    float b = brightness(image.pixels[i]);
    if (b < Max && b > Min) {
      result.pixels[i] = image.pixels[i];
    } else {
      result.pixels[i] = color(0, 0, 0);
    }
  }
  return result;
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

void selectHue(PImage img, int max, int min) {
  if (max < min) {
    int b = min;
    min = max;
    max = b;
  }
  color c = color(0, 0, 0);
  for (int i = 0; i < img.width * img.height; ++i) {
    float h = hue(img.pixels[i]);
    if (max >= h && h >= min) {
      result.pixels[i] = img.pixels[i];
    } else {
      result.pixels[i] = c;
    }
  }
}

PImage convolute(PImage img1, float[][] kernel, int side) {
  PImage result = createImage(img.width, img.height, ALPHA);
  for (int i = side/2; i < img1.height - side/2; ++i) {
    for (int j = side/2; j < img1.width - side/2; ++j) {
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
    result.pixels[i] = color(0, 0, 0);
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
      if (b > max ) {
        max = b;
      }
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


ArrayList<PVector> hough(PImage edgeImg, int nLines ) {
  float discretizationStepsPhi = 0.06f;
  float discretizationStepsR = 2.5f;
  ArrayList<PVector> result = new ArrayList();
  // dimensions of the accumulator
  int phiDim = (int) (Math.PI / discretizationStepsPhi);
  int rDim = (int) (((edgeImg.width + edgeImg.height) * 2 + 1) / discretizationStepsR);
  // our accumulator (with a 1 pix margin around)
  int[] accumulator = new int[(phiDim + 2) * (rDim + 2)];
  // Fill the accumulator: on edge points (ie, white pixels of the edge
  // image), store all possible (r, phi) pairs describing lines going
  // through the point.
  for (int y = 0; y < edgeImg.height; y++) {
    for (int x = 0; x < edgeImg.width; x++) {
      // Are we on an edge?
      if (brightness(edgeImg.pixels[y * edgeImg.width + x]) != 0) {
        // ...determine here all the lines (r, phi) passing through
        // pixel (x,y), convert (r,phi) to coordinates in the
        // accumulator, and increment accordingly the accumulator.
        // Be careful: r may be negative, so you may want to center onto
        // the accumulator with something like: r += (rDim - 1) / 2
        for (int i = 0; i < phiDim; ++i) {
          double phi = i*discretizationStepsPhi;
          double r = x*Math.cos(phi) + y*Math.sin(phi);
          r /= discretizationStepsR;
          r+= (rDim - 1) / 2;
          accumulator[(int) ((i+1) * (rDim+2)) + (int)(r+1)] += 1;
        }
      }
    }
  }

  ArrayList<Integer> bestCandidates = new ArrayList();
  // size of the region we search for a local maximum
  int neighbourhood = 10;
  // only search around lines with more that this amount of votes
  // (to be adapted to your image)
  int minVotes = 200;
  for (int accR = 0; accR < rDim; accR++) {
    for (int accPhi = 0; accPhi < phiDim; accPhi++) {
      // compute current index in the accumulator
      int idx = (accPhi + 1) * (rDim + 2) + accR + 1;
      if (accumulator[idx] > minVotes) {
        boolean bestCandidate=true;
        // iterate over the neighbourhood
        for (int dPhi=-neighbourhood/2; dPhi < neighbourhood/2+1; dPhi++) {
          // check we are not outside the image
          if ( accPhi+dPhi < 0 || accPhi+dPhi >= phiDim) continue;
          for (int dR=-neighbourhood/2; dR < neighbourhood/2 +1; dR++) {
            // check we are not outside the image
            if (accR+dR < 0 || accR+dR >= rDim) continue;
            int neighbourIdx = (accPhi + dPhi + 1) * (rDim + 2) + accR + dR + 1;
            if (accumulator[idx] < accumulator[neighbourIdx]) {
              // the current idx is not a local maximum!
              bestCandidate=false;
              break;
            }
          }
          if (!bestCandidate) break;
        }
        if (bestCandidate) {
          // the current idx *is* a local maximum
          bestCandidates.add(idx);
        }
      }
    }
  }



  //println("size:" + bestCandidates.size());
  bestCandidates.sort(new HoughComparator(accumulator));
  for (int i = 0; i < nLines && i < bestCandidates.size(); ++i) {
    int idx = bestCandidates.get(i);
    // first, compute back the (r, phi) polar coordinates:
    int accPhi = (int) (idx / (rDim + 2)) - 1;
    int accR = idx - (accPhi + 1) * (rDim + 2) - 1;
    float r = (accR - (rDim - 1) * 0.5f) * discretizationStepsR;
    float phi = accPhi * discretizationStepsPhi;
    // Cartesian equation of a line: y = ax + b
    // in polar, y = (-cos(phi)/sin(phi))x + (r/sin(phi))
    // => y = 0 : x = r / cos(phi)
    // => x = 0 : y = r / sin(phi)
    result.add(new PVector(r, phi));
    // compute the intersection of this line with the 4 borders of
    // the image
    int x0 = 0;
    int y0 = (int) (r / sin(phi));
    int x1 = (int) (r / cos(phi));
    int y1 = 0;
    int x2 = edgeImg.width;
    int y2 = (int) (-cos(phi) / sin(phi) * x2 + r / sin(phi));
    int y3 = edgeImg.width;
    int x3 = (int) (-(y3 - r / sin(phi)) * (sin(phi) / cos(phi)));
    // Finally, plot the lines
    stroke(204, 102, 0);
    if (y0 > 0) {
      if (x1 > 0)
        line(x0, y0, x1, y1);
      else if (y2 > 0)
        line(x0, y0, x2, y2);
      else
        line(x0, y0, x3, y3);
    } else {
      if (x1 > 0) {
        if (y2 > 0)
          line(x1, y1, x2, y2);
        else
          line(x1, y1, x3, y3);
      } else
        line(x2, y2, x3, y3);
    }
  }
  return result;
}

class HoughComparator implements java.util.Comparator<Integer> {
  int[] accumulator;
  public HoughComparator(int[] accumulator) {
    this.accumulator = accumulator;
  }
  @Override
    public int compare(Integer l1, Integer l2) {
    if (accumulator[l1] > accumulator[l2]
      || (accumulator[l1] == accumulator[l2] && l1 < l2)) return -1;
    return 1;
  }
}

ArrayList<PVector> getIntersections(ArrayList<PVector> lines) {
  ArrayList<PVector> intersections = new ArrayList<PVector>();
  for (int i = 0; i < lines.size() - 1; i++) {
    PVector l1 = lines.get(i);
    for (int j = i + 1; j < lines.size(); j++) {
      PVector l2 = lines.get(j);
      // compute the intersection and add it to ’intersections’
      
      double d = cos(l2.y) * sin(l1.y) - cos(l1.y) * sin(l2.y);
      float x = (float)((l2.x * sin(l1.y) - l1.x * sin(l2.y))/d);
      float y = (float)((-l2.x * cos(l1.y) + l1.x * cos(l2.y))/d);
      intersections.add(new PVector(x, y));
      
      // draw the intersection
      fill(255, 128, 0);
      ellipse(x, y, 10, 10);
    }
  }
  return intersections;
}