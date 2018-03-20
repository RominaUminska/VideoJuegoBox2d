class Particle {


  Body body;
  float r;
  boolean delete = false;
  color col;

  Particle(float x, float y, float r_) {
    r = r_;

    makeBody(x, y, r);
    body.setUserData(this);
    col = color(255,255,0);
  }

  void killBody() {
    box2d.destroyBody(body);
  }

  void delete() {
    delete = true;
  }


  void change() {
    col = color(255, 0, 0);
  }
  void change2(){
    col = color(0,0,255);
  }
  boolean done() {

    Vec2 pos = box2d.getBodyPixelCoord(body);

    if ( pos.x >= 360+r*2 && pos.x <= 400+r*2 && pos.y > 300 && pos.y < 320 && touch>=3|| delete) {
      killBody();
      return true;
    }
    return false;
  }

  void display() {

    Vec2 pos = box2d.getBodyPixelCoord(body);

    float a = body.getAngle();
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(a);
    fill(col);
    stroke(0);
    strokeWeight(1);
    ellipse(0, 0, r*2, r*2);
    popMatrix();
  }
  
    void attract(float x,float y) {

    Vec2 worldTarget = box2d.coordPixelsToWorld(x,y);   
    Vec2 bodyVec = body.getWorldCenter();

    worldTarget.subLocal(bodyVec);
    worldTarget.normalize();
    worldTarget.mulLocal((float) 60);
    body.applyForce(worldTarget, bodyVec);
  }


  void makeBody(float x, float y, float r) {

    BodyDef bd = new BodyDef();

    bd.position = box2d.coordPixelsToWorld(x, y);
    bd.type = BodyType.DYNAMIC;
    body = box2d.createBody(bd);
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    fd.density = .5;
    fd.friction = 5;
    fd.restitution = .5;
    body.createFixture(fd);
    body.setAngularVelocity(random(-10, 10));
  }
}
