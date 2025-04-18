//
//  ViewController.swift
//  PersonRecordManager
//
//  Created by Amam Pratap Singh on 20/02/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet var mainTableView: UITableView!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // Reference to managed object context.
    var items: [Person]?

    override func viewDidLoad() {
        super.viewDidLoad()

        configTheme()
        configDependencies()
    }

    private func configTheme(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addPerson)
        )

        self.navigationItem.title = "Person Details"
    }

    private func configDependencies() {
        mainTableView.dataSource = self
        mainTableView.delegate = self
        fetchPeople()
    }

    private func fetchPeople() {
        do {
            let request = Person.fetchRequest() as NSFetchRequest<Person>
            self.items = try context.fetch(request)
            DispatchQueue.main.async {
                self.mainTableView.reloadData()
            }
        } catch {
            print("Unable to fetch request")
        }
    }

    @objc func addPerson() {
        let alert = UIAlertController(title: "Add Person", message: "Enter Details Carefully", preferredStyle: .alert)

        alert.addTextField { (username) in
            username.text = ""
            username.placeholder = "Enter Name"
        }

        alert.addTextField { (gender) in
            gender.text = ""
            gender.placeholder = "Enter Age"
        }

        alert.addTextField { (age) in
            age.text = ""
            age.placeholder = "Enter Gender"
        }

        let submitButton = UIAlertAction(title: "Add", style: .default) { action in
            let textfield0 = alert.textFields![0]
            let textfield1 = alert.textFields![1]
            let textfield2 = alert.textFields![2]

//          Create a person object
            let newPerson = Person(context: self.context)
            newPerson.name = textfield0.text
            newPerson.age = Int64(textfield1.text ?? "0") ?? 0
            newPerson.gender = textfield2.text

            do{
                try self.context.save()
            } catch {
                print("Error in saving the data")
            }

            self.fetchPeople()
        }
        alert.addAction(submitButton)

        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelButton)

        self.present(alert, animated: true, completion: nil)
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainTableView.dequeueReusableCell(withIdentifier: "Cell") as! PersonDetailTableViewCell
        cell.nameLabel.text = items?[indexPath.row].name
        cell.genderLabel.text = items?[indexPath.row].gender
        cell.ageLabel.text = "\(items?[indexPath.row].age ?? 0)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = self.items![indexPath.row]

        let alert = UIAlertController(title: "Edit Person", message: "Edit Details Carefully", preferredStyle: .alert)
        alert.addTextField()
        alert.addTextField()
        alert.addTextField()

        let textField0 = alert.textFields![0]
        textField0.text = person.name

        let textField1 = alert.textFields![1]
        textField1.text = String(person.age)

        let textField2 = alert.textFields![2]
        textField2.text = person.gender

        let saveButton = UIAlertAction(title: "Save", style: .default) {action in

            let textfield0 = alert.textFields![0]
            let textfield1 = alert.textFields![1]
            let textfield2 = alert.textFields![2]

            person.name = textfield0.text
            person.age = Int64(textfield1.text ?? "0") ?? 0
            person.gender = textfield2.text

            do{
                try self.context.save()
            } catch {
                print("Error while saving the Edit Name")
            }

            self.fetchPeople()
        }

        alert.addAction(saveButton)

        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelButton)

        self.present(alert, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _,_,_  in
            let personToRemove = self.items![indexPath.row]
            self.context.delete(personToRemove)
            do {
                try self.context.save()
            } catch {
                print("Error in saving data while deleting")
            }
            self.fetchPeople()
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
