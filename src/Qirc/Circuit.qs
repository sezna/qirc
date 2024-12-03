import Std.Arrays.IndexOf;
import Qirc.NamedQubit;
struct Circuit {
    operations : Gates.Gate[]
}

function Append(gates : Gates.Gate[], circuit : Circuit) : Circuit {
    new Circuit {
        operations = circuit.operations + gates
    }
}

function EmptyCircuit() : Circuit {
    new Circuit {
        operations = []
    }
}

operation Execute(circuit : Circuit) : Unit {
    for gate in circuit.operations {
        if (gate.name == "H") {
            H(gate.qubits[0].qubit);
        } elif (gate.name == "CNOT") {
            CNOT(gate.qubits[0].qubit, gate.qubits[1].qubit);
        } elif (gate.name == "Measure") {
            let result1 = M(gate.qubits[0].qubit);
            let result2 = M(gate.qubits[1].qubit);
            Message($"Measured {gate.qubits[0].name} to be {result1} and {gate.qubits[1].name} to be {result2}");
        } elif (gate.name == "CZ") {
            CZ(gate.qubits[0].qubit, gate.qubits[1].qubit);
        }
    }
}

operation NTimes(n : Int, circ : Circuit) : Unit {
    for i in 1..n {
        Execute(circ);
    }
}

function Diagram(circ : Circuit) : Unit {
    // prints out in ascii art the diagram
    mutable distinct_qubits : NamedQubit[] = [];

    mutable position = 0;
    for gate in circ.operations {
        for qubit in gate.qubits {
            if (not Std.Arrays.Any(x -> x.name == qubit.name, distinct_qubits)) {
                set distinct_qubits += [qubit];
            }
        }
    }

    mutable output_lines : String[][] = Std.Arrays.Mapped(x -> [x.name], distinct_qubits);

    for gate in circ.operations {
        mutable name = BreakCircuitName(gate.name);
        mutable gate_shown = false;

        for qubit in gate.qubits {
            let qubit_index = IndexOf(x -> x.name == qubit.name, distinct_qubits);
            while Length(output_lines[qubit_index]) <= position {
                set output_lines w/= qubit_index <- output_lines[qubit_index] + ["-"];
            }

            if gate_shown {
                set name = [" ", size = Length(name)];
            }

            let to_append = if Length(gate.qubits) > 1 { ["-", "|"] + name + ["|", "-"] } else {["-", "-"] + name  + ["-", "-"] };

            set output_lines w/= qubit_index <- output_lines[qubit_index] + to_append;

            set gate_shown = true;

        }

         set position += Length(name) + 4;
    }

    for line in output_lines {
        mutable line_str = "";
        for gate in line {
            set line_str += gate;
        }
        Message(line_str);
    }
}

function BreakCircuitName(gate_name : String) : String[] {
    if gate_name == "H" {
        ["H"]
    } elif gate_name == "CNOT" {
        ["C", "N", "O", "T"]
    } elif gate_name == "Measure" {
        ["M", "e", "a", "s", "u", "r", "e"]
    } elif gate_name == "CZ" {
        ["C", "Z"]
    } else { ["Unknown Gate"] }
}



export Append, Circuit;