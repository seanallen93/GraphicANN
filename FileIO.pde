/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
Filename: FileIO.pde
Version: 1.1.0
Author: Sean Allen
Last Modified: 2/13/17
*/
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//---------------------------------------------------------------------------------------------------
// Network Load/Save Functions
//---------------------------------------------------------------------------------------------------
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
Filename: FileIO.pde
Version: 1.1.0
Author: Sean Allen
Last Modified: 2/20/17
*/
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
String saveFilename = "NetSave";
String loadFilename = "NetSave.csv";

//---------------------------------------------------------------------------------------------------
// Network Load/Save Functions
//---------------------------------------------------------------------------------------------------
void saveNetwork() {

  Table table;
  table = new Table();
  
  String outputBin = "false";
  
  // Create columns for each necessary neuron variable.
  //
  table.addColumn("X");                            // X Array Coordinate
  table.addColumn("Y");                            // Y Array Coordinate
  table.addColumn("x");                            // X Pixel Coordinate
  table.addColumn("y");                            // Y Pixel Coordinate
  table.addColumn("numberOfInputs");               // Number of Inputs
  table.addColumn("size");                         // Body size
  table.addColumn("bias");                         // Bias
  table.addColumn("binary");                       // Binary output (Boolean)
  table.addColumn("range");                        // Range
  table.addColumn("threshold");                    // Threshold
  table.addColumn("recharge");                     // Recharge
  table.addColumn("hp");                           // HP
  table.addColumn("hp_period");                    // HP Period
  table.addColumn("hp_gain");                      // HP Gain
  table.addColumn("hp_loss");                      // HP Loss
  table.addColumn("LC");                           // Learning Constant
  table.addColumn("LT");                           // Learning Threshold
  table.addColumn("MAX_WEIGHT");                   // Maximum Weight
  table.addColumn("MAX_WEIGHT_CHANGE");            // Maximum Weight Change
  table.addColumn("Weights");                      // Input Weights
  
  // Scan the network and add needed neuron variables.
  //
  for(int r = 0; r < NN[net].nRows; r++)
  {
    for(int c = 0; c < NN[net].nColumns; c++)
    {
      TableRow newRow = table.addRow();
      String weights = "";
      newRow.setInt("X", r);
      newRow.setInt("Y", c);
      newRow.setInt("x", NN[net].neuron[r][c].x);
      newRow.setInt("y", NN[net].neuron[r][c].y);
      newRow.setInt("numberOfInputs", NN[net].neuron[r][c].numberOfInputs);
      newRow.setInt("size", NN[net].neuron[r][c].bodySize);
      newRow.setFloat("bias", NN[net].neuron[r][c].bias);
      if(NN[net].neuron[r][c].outputBinary) 
        outputBin = "true";
      newRow.setString("binary", outputBin);
      newRow.setFloat("range", NN[net].neuron[r][c].range);
      newRow.setFloat("threshold", NN[net].neuron[r][c].threshold);
      newRow.setInt("recharge", NN[net].neuron[r][c].recharge);
      newRow.setFloat("hp", NN[net].neuron[r][c].hp);
      newRow.setInt("hp_period", NN[net].neuron[r][c].hp_period);
      newRow.setFloat("hp_gain", NN[net].neuron[r][c].hp_gain);
      newRow.setFloat("hp_loss", NN[net].neuron[r][c].hp_loss);
      newRow.setFloat("LC", NN[net].neuron[r][c].LC);
      newRow.setFloat("LT", NN[net].neuron[r][c].LT);
      newRow.setFloat("MAX_WEIGHT", NN[net].neuron[r][c].MAX_WEIGHT);
      newRow.setFloat("MAX_WEIGHT_CHANGE", NN[net].neuron[r][c].MAX_WEIGHT_CHANGE);
      for(int i = 0; i < NN[net].neuron[r][c].weights.length; i++) // Cycle through weights
      {
        if(i == NN[net].neuron[r][c].weights.length - 1)
          weights += NN[net].neuron[r][c].weights[i];
        else
          weights += NN[net].neuron[r][c].weights[i] + "|";
      }
      newRow.setString("Weights", weights);
    }
  }
  
  saveTable(table, saveFilename + ".csv");
  println(saveFilename + ".csv has been saved.");
}

//------------------------------------------------------------------------------------------------
// Unfinished Functions
//------------------------------------------------------------------------------------------------

/*
String loadFilename = "NetSave.csv";

void loadNetwork() {
  Table table = loadTable(loadFilename, "header");
  // Coordinate values
  int loadX = 0;
  int loadY = 0; 
  
  // Scan the flie and get the number of rows and columns.
  //
  for (TableRow row : table.rows()) 
  {
      int loadx = row.getInt("X");
      int loady = row.getInt("Y");
      
      // Save the highest value for each.
      if(loadx > loadX)
        loadX = loadx;
      if(loady > loadY)
        loadY = loady;
  }
  
  // Create new network
  NN[net] = new NeuralNetwork(loadX, loadY, learningConstant_, learningThreshold_, BP_State_);
  
  
  for (TableRow row : table.rows()) 
  { 
    
    
*/