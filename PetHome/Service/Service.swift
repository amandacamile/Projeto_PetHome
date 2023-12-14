import UIKit

class Service {
    var accessTokens: String? = ""
    
    func fetchAnimals(currentPage: Int, _ completion: @escaping (AnimalsList?) -> Void) {
        let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            getTokens { token in
                defer {
                    dispatchGroup.leave()
                }

                guard let token = token else {
                    completion(nil)
                    return
                }

                let urlString = URL(string: "https://api.petfinder.com/v2/animals")!
                var request = URLRequest(url: urlString)

                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    if let _ = error {
                        completion(nil)
                        return
                    }

                    if let data = data {
                        let jsonDecodable = JSONDecoder()
                        jsonDecodable.keyDecodingStrategy = .convertFromSnakeCase
                        do {
                            let animals = try jsonDecodable.decode(AnimalsList.self, from: data)
                            print("&& sucesso: \(animals)")
                            completion(animals)
                        } catch {
                            print("&& erro: \(error)")
                            completion(nil)
                        }
                    }
                }
                task.resume()
            }
            dispatchGroup.wait()
    }
    
    func getTokens(completion: @escaping (String?) -> Void) {
       let tokenURL = URL(string: "https://api.petfinder.com/v2/oauth2/token")!
       let clientId: String = "jzReeSDZAktQCYJrIcq0Rti0I60q9OxK6MexktPsr4SISLUWGy"
       let clientSecret: String = "JkjlU0t1EBfUtb70xN6JGa8E8gSARBPtd7Xj3pFq"

       var body = "grant_type=client_credentials"
       body += "&client_id=\(clientId)"
       body += "&client_secret=\(clientSecret)"

       var request = URLRequest(url: tokenURL)
       request.httpMethod = "POST"
       request.httpBody = body.data(using: .utf8)
       request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

       let session = URLSession.shared

       let task = session.dataTask(with: request) { data, _, error in
           guard let data = data, error == nil else {
               print("Erro ao obter token:", error?.localizedDescription ?? "Erro desconhecido")
               completion(nil)
               return
           }

           do {
               let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
               if let accessToken = json?["access_token"] as? String {
                   print("Sucesso ao obter token. Resposta:", accessToken)
                   completion(accessToken)
               } else {
                   print("Erro ao obter token. Resposta:", json ?? "")
                   completion(nil)
               }
           } catch {
               print("Erro ao processar dados JSON:", error.localizedDescription)
               completion(nil)
           }
       }

       task.resume()
    }
}
