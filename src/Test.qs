import Qirc.Circuit.Diagram;
import Qirc.Circuit.EmptyCircuit;
import Qirc.Circuit.Circuit;
@EntryPoint()
operation QuantumTeleportation(): Unit {
    //  circuit = cirq.Circuit()
    let circ = EmptyCircuit();

    //  Get the three qubits involved in the teleportation protocol.
    use qs = Qubit[3];
    let msg =  Qirc.CreateNamedQubit("msg    ", qs[0]);
    let alice = Qirc.CreateNamedQubit("alice  ", qs[1]);
    let bob = Qirc.CreateNamedQubit("bob    ", qs[2]);

    // Create a Bell state shared between Alice and Bob.
    // equivalent to circ.append(cirq.H(alice), cirq.CNOT(alice, bob))
    let circ = Qirc.Circuit.Append([Qirc.H(alice), Qirc.CNOT(alice, bob)], circ);

    // Bell measurement of the Message and Alice's entangled qubit.
    // equivalent to circ.append(cirq.H(msg), cirq.CNOT(msg, alice), cirq.measure(msg, alice))
    let circ = Qirc.Circuit.Append([Qirc.CNOT(msg, alice), Qirc.H(msg), Qirc.Measure(msg, alice)], circ);

    // Uses the two classical bits from the Bell measurement to recover the
    // original quantum message on Bob's entangled qubit.
    // equivalent to circ.append(cirq.CNOT(alice, bob), cirq.CZ(msg, bob))
    let circ = Qirc.Circuit.Append([Qirc.CNOT(alice, bob), Qirc.CZ(msg, bob)], circ);

    Qirc.Circuit.Execute(circ);

    Qirc.Circuit.NTimes(2, circ);

    Diagram(circ);

    ResetAll(qs);
}