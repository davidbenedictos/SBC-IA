#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <string>

using namespace std;

//struct Libro
struct Libro {
    string titulo;
    string escritoPor;
    string perteneceAGenero;
    string fecha;
    int paginas;
    string idioma;
    int complejidad;
    int popularidad;
    int valoracion;
};

//leer CSV y almacenar los datos en un vector de libros
vector<Libro> leerCSV(const string& archivo) {
    vector<Libro> libros;
    ifstream inputFile(archivo);

    if (!inputFile.is_open()) {
        cerr << "Error al abrir el archivo." << endl;
        return libros;
    }

    string linea;
    // Leer cada línea del archivo CSV
    while (getline(inputFile, linea)) {
        istringstream ss(linea);
        string campo;
        Libro libro;
   
        getline(ss, libro.titulo, ',');
        getline(ss, libro.escritoPor, ',');
        getline(ss, libro.perteneceAGenero, ',');
        getline(ss, libro.fecha, ',');
        ss >> libro.paginas;
        getline(ss, campo, ','); 
        getline(ss, libro.idioma, ',');
        ss >> libro.complejidad;
        getline(ss, campo, ','); 
        ss >> libro.popularidad;
        getline(ss, campo, ','); 
        ss >> libro.valoracion;

        libros.push_back(libro);
    }

    inputFile.close();
    return libros;
}

void escribirInstancias(const vector<Libro>& libros) {
    ofstream outputFile("instancias.clp");

    if (!outputFile.is_open()) {
        cerr << "Error al abrir el archivo de salida." << endl;
        return;
    }

    outputFile << "(definstances instances" << endl;

    for (size_t i = 0; i < libros.size(); ++i) {
        const Libro& libro = libros[i];

        outputFile << "    ([instancia" << i << "] of Libro" << endl;
        outputFile << "         (Titulo \"" << libro.titulo << "\")" << endl;
        outputFile << "         (EscritoPor [\"" << libro.escritoPor << "\"])" << endl;
        outputFile << "         (PerteneceAGenero [\"" << libro.perteneceAGenero << "\"])" << endl;
        outputFile << "         (Fecha \"" << libro.fecha << "\")" << endl;
        outputFile << "         (Paginas " << libro.paginas << ")" << endl;
        outputFile << "         (Idioma \"" << libro.idioma << "\")" << endl;
        outputFile << "         (Complejidad " << libro.complejidad << ")" << endl;
        outputFile << "         (Popularidad " << libro.popularidad << ")" << endl;
        outputFile << "         (Valoracion " << libro.valoracion << ")" << endl;
        outputFile << "    )" << endl;
    }

    outputFile << ")" << endl;

    outputFile.close();
}



int main() {

    vector<Libro> libros = leerCSV("dataset.csv");

    escribirInstancias(libros);

    cout << "Instancias escritas en el archivo instancias.clp." << endl;

    
}
