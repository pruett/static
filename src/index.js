const myName = "kevin";

class Kevin {
  get name() {
    return "Kevin";
  }

  callMe() {
    console.log(`allo ${this.name}`);
  }
}

const aKevin = new Kevin();
const greeting = aKevin.callMe();

export default greeting;
