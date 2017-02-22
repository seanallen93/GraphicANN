/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
Filename: Neuron.pde
 Version: 1.1.0
 Author: Sean Allen
 Last Modified: ~2/10/17
 */
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

PFont font;

class Neuron
{
  float[] inputs;
  float[] lastInput;
  float[] weights;

  int bodySize;               // Size of neuron
  int numberOfInputs;         // Number of inputs.
  int x, y;                   // Coordinates
  boolean isSelected;         // Value for whether or not the neuron is selected.
  int hue;                    // Color intensity

  // Firing Variables
  float bias;                 // A constant value that is added to the sum of the activation
  boolean outputBinary;       // Control whether the neuron only fires a -1 or 1. Outputs total activation otherwise.
  float output;               // Output value of the neuron
  float range;                // Range of input values ( -n to n).
  float threshold;            // Firing threshold
  float activation;           // Value of combined inputs
  int charge_delay;           // Minimum delay in between firing.
  int recharge;               // Delay(ms) between firing
  int lastDischarge;          // Time of last firing.
  boolean fired;              // Boolean to indicate whether the neuron has fired.
  float fuzz = 0;

  // Nitric Oxide Variables
  boolean alive = true;         // 
  float hp = 255;               // Health of neuron.
  int hp_period;                // Number of cycles before a neuron loses hp.
  int hp_cycle_cnt;             // Counter for health cycles
  float hp_gain;                // Amount of hp gained per firing.
  float hp_loss;                // Amount of hp lost per hp period.
  int hp_period_cnt;            // Counter for hp periods that have passed.
  float hp_max = 255;           // Maximum hp
  float hp_min = 0;             // Minimum hp

  // Learning Variables
  float LC;
  float LT;
  float MAX_WEIGHT_CHANGE = 2;
  float MAX_WEIGHT = 5; 
  float smoothing;
  float lastError = 0;




  // Constructor
  //
  Neuron(int x_, int y_, int inputs_, boolean outputBinary_, int bias_, float range_, float threshold_, int bsize, 
    int recharge_, float hp_, int hp_period_, float hp_gain_, float hp_loss_, float LC_, float LT_)
  {
    // Create font.
    font = createFont("Silom-4.vlw", 12);
    textFont(font);

    // Set variables to parameters.
    bodySize = bsize;
    numberOfInputs = inputs_;
    x = x_;
    y = y_;
    outputBinary = outputBinary_;
    bias = bias_;
    //range = range_;
    threshold = threshold_;
    recharge = recharge_;
    hp = hp_;
    hp_period = hp_period_;
    hp_gain = hp_gain_;
    hp_loss = hp_loss_;
    LC = LC_;
    LT = LT_;

    // Create the array of inputs.
    inputs = new float[inputs_];
    lastInput = new float[inputs_];
    // Create the array of weights and assign random values.
    weights = new float[inputs_];
    for ( int i = 0; i < weights.length; i++)
    {
      weights[i] = random(-1, 1);
    }
  }



  // The drawNeuron() function draws and colors the neuron.
  //
  void drawNeuron()
  {
    // Highlight the neuron if it is selected.
    if (isSelected == true)
    {
      stroke(0, 250, 50); // Yellow
      strokeWeight(3);
      ellipse(x, y, bodySize + 5, bodySize + 5);
    }

    if (alive) // Color the neurons based on excitation while alive.
    {
      // Change the neurons color between red(negative output) and blue(positive output).
      hue = int(feedforward() * 255);
      if (hue >= 0)
        fill(hue, 0, 0, hp); // Red
      if (hue < 0)
        fill(0, 0, abs(hue), hp); //Blue
      // Draw the body of the neuron.
      strokeWeight(2);
      stroke(0);
      //fill(abs(hue));
      ellipse(x, y, bodySize, bodySize);
      stroke(255);
      fill(255);
    }

    if (!alive)
    {
      // Draw the body of the neuron black.
      stroke(0, 0, 0, hp); //Black
      strokeWeight(4);
      ellipse(x, y, bodySize, bodySize);
    }
  }

  void nitric(boolean fired)
  {


    if (hp_cycle_cnt < hp_period)
    {
      if (fired)
      {
        if (hp < hp_max - hp_gain)
        {
          hp += hp_gain;
        }
      } else
      {   
        if (hp > hp_min)
        {
          hp -= hp_loss;
        }
        if (hp <= 0)
        {
          killNeuron();
        }
      }



      hp_cycle_cnt = 0;
      hp_period_cnt++;
    }
  }

  void killNeuron()
  {
    alive = false;
    activation = 0;
    output = 0;
  }


  // The feedforward() function calculates the output value based on the input
  // value and the learning constant.
  //
  float feedforward()
  {
    if (alive)
    {
      activation = 0; // Sum of all values.

      // Calculate the sum.
      for (int i = 0; i < inputs.length; i++)
        activation += inputs[i] * weights[i];

      // Add the bias to activation.
      activation += bias;

      // Calculate the time when firing delay is complete.
      int nextDischarge = recharge + lastDischarge;
      if (nextDischarge <= millis())  
      {
        // Fire if the threshold is met. 
        if (activation >= threshold)
        {
          // Check output format
          if (outputBinary == true)
            output = 1;
          else if (outputBinary == false)
            output = activation - threshold + fuzz;

          fired = true;
          lastDischarge = millis(); // Set last
        } else if (activation <= -threshold)
        {
          // Check output format
          if (outputBinary == true)
            output = -1;
          else if (outputBinary == false)
            output = activation + threshold - fuzz;
          fired = true;
          lastDischarge = millis(); // Set last
        } else
        {
          output = 0;
          fired = false;
        }

        // Copy input values into array for read out.
        for ( int i = 0; i < numberOfInputs; i++)
          lastInput[i] = inputs[i];
        // Change input values back to 0.
        for ( int i = 0; i < numberOfInputs; i++)
        {
          inputs[i] = 0;
        }
        nitric(fired);
        //if(fired)
        //adjustWeights(error);
      }
    }

    hp_cycle_cnt++;
    return output;
  }

  void staticDrawNeuron()
  {
    // Highlight the neuron if it is selected.
    if (isSelected == true)
    {
      stroke(0, 250, 50); // Yellow
      strokeWeight(3);
      ellipse(x, y, bodySize + 5, bodySize + 5);
    }

    if (alive) // Color the neurons based on excitation while alive.
    {
      // Change the neurons color between red(negative output) and blue(positive output).
      hue = int(activation * 255);
      if (activation >= 0)
        stroke(hue, 0, 0, hp); // Red
      else if (activation < 0)
        stroke(0, 0, abs(hue), hp); //Blue
      // Draw the body of the neuron.
      strokeWeight(4);
      ellipse(x, y, bodySize, bodySize);
    }

    if (!alive)
    {
      // Draw the body of the neuron black.
      stroke(0, 0, 0, hp); //Black
      strokeWeight(4);
      ellipse(x, y, bodySize, bodySize);
    }
  }

  void resetWeights()
  {
    for (int i = 0; i < weights.length; i++)
      weights[i] = random(-range, range);
  }

  //----------------------------------------------------------------------------------
  // Learning Functions
  //----------------------------------------------------------------------------------


  void adjustWeights(float error)
  {
    for (int i = 0; i < weights.length; i++)
    {
      // if(error > abs(LT))
      //{
      float weightChange = (LC * error * inputs[i]);
      if (weightChange >= MAX_WEIGHT_CHANGE)
      {
        weightChange = MAX_WEIGHT_CHANGE;
      } else if (weightChange <= -MAX_WEIGHT_CHANGE)
      {
        weightChange = -MAX_WEIGHT_CHANGE;
      } else
      {
        if (weights[i] >= MAX_WEIGHT)
        {
          //weights[i] -= weightChange; 
          weights[i] = random(-range, range);
        } else if (weights[i] <= -MAX_WEIGHT)
        {
          //weights[i] += weightChange;
          weights[i] = random(-range, range);
        } else
        {
          weights[i] += weightChange;
        }
        //}
      }
    }
    lastError = error;
  }


  float kudos()
  {
    float errorDiff = error - lastError;
    return activation * errorDiff;
  }

  float smoothing(float netAvg) // IDK why this works.
  {
    float s = activation - netAvg;
    return s;
  }
}  // End of class