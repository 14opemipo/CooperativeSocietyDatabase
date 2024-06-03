import List "mo:base/List";

actor CooperativeSociety {

  var personDatabase = List.nil<Person>();

  type Person = {
    firstname: Text;
    lastname: Text;
    age: Nat;
    gender: Gender;
    accountNumber: Nat;
    occupation: Text;
    amount: Nat;
  };

  type pay = Payment;

  type Payment = {
    #BankTransfer;
    #Card;
  };

  type Gender = {
    #Male;
    #Female;
  };
  type PersonOperationResult = {
      #Success : Person;
      #Failure : Text;
    };
  public query func getAllPersons() : async List.List<Person> {
    return personDatabase;
  };
 
  public query func batchAddPerson(newPersonList:List.List<Person>): async Text{
   let newList = List.append<Person>(newPersonList, personDatabase);
   personDatabase := newList;
   return "successfully batch added people";
  };

  public query func addNewPerson(newPerson:Person): async Text{
   let newList = List.push<Person>(newPerson, personDatabase);
   personDatabase := newList;
   return "successfully added person" # " " # newPerson.lastname;
  };

  public query func getAllPersonByfirstname(firstname: Text): async List.List<Person>{
    let matchedPerson = List.filter<Person>(personDatabase, func person {
      if(person.firstname == firstname){
        return true;
      }
      else{
        return false;
      }
    }
   );
   return matchedPerson;
  };


 public query func getPerson(accountNumber:Nat): async PersonOperationResult {
      let matchedPerson = List.find<Person>(personDatabase, func person {   
        if(person.accountNumber == accountNumber){
          return true;
        }
        else{
          return false;
        }
       }
      );

      switch(matchedPerson){
        case(null){
          return #Failure "Reciever not found";
        };

        case(?matchedPerson){
          return #Success matchedPerson;
        }
      }
    }; 
// can't mutate something remember the whole blockchain p.
// another choice is to declare the amount in the object using var
// but that means you would not be able to return it in a query, i leave that to you.
 public query func sendMoney(firstname:Text, lastname:Text, accountNumber:Nat, pay:Payment, amount:Nat): async Nat{
    let receiver = List.find<Person>(personDatabase, func person { person.lastname == lastname });
    switch(receiver){
      case(?receiver){
        return receiver.amount + amount;
      };
      case(null){
        return 1;
      }
    }
  };

};