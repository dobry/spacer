// represents a cloud
class Cloud
{
  public int points; // how many point to gain/lose
  public int cloud; // number of cloud graphics
  public int smile; // number of smile graphics
  public int note; // note symbolized by the cloud
  public boolean taken; // true if cloud is taken and shouldn't be visible anymore
  public float timing;
  
  public Cloud(int points, int note, float time, int cloud, int smile)
  {
    this.points = points;
    this.note = note;
    this.timing = time;
    this.cloud = cloud;
    this.smile = smile;
    this.taken = false;
  }
  
  public Cloud(int points, int note, float time)// = 50)
  {
    this.points = points;
    this.note = note;
    this.timing = time;
    this.cloud = int(random(1,4));
    this.smile = int(random(1,7));
    this.taken = false;
  }
}
