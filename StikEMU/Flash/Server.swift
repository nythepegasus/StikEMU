//
//  Server.swift
//  StikEMU
//
//  Created by Blu on 10/11/24.
//

import SwiftUI
import Swifter

class FlashEmulatorServer: ObservableObject {
    let server = HttpServer()

    init() {
        setupRoutes()
    }

    func start() {
        do {
            try server.start(8080)
            print("Server has started ( port = 8080 )")
        } catch {
            print("Server start error: \(error)")
        }
    }

    func stop() {
        server.stop()
    }

    private func setupRoutes() {
        // Serve the main HTML page
        server["/"] = { request in
            return .ok(.html(self.createHTML()))
        }

        // Serve the SWF file
        server["/testing.swf"] = { request in
            guard let swfPath = Bundle.main.path(forResource: "testing", ofType: "swf"),
                  let swfData = try? Data(contentsOf: URL(fileURLWithPath: swfPath)) else {
                return .notFound
            }
            return .raw(200, "application/x-shockwave-flash", [:], { writer in
                try writer.write(swfData)
            })
        }
    }

    private func createHTML() -> String {
        """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>
                body, html {
                    margin: 0;
                    padding: 0;
                    height: 100%;
                    width: 100%;
                    background-color: #000;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    overflow: hidden;
                }
                #flash-player {
                    width: 100vw;
                    height: 100vh;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    position: relative;
                }
                /* Ensure the Ruffle player scales to fill the container */
                #flash-player > .ruffle-container {
                    width: 100%;
                    height: 100%;
                    transform: scale(1);
                    transform-origin: top left;
                }
            </style>
            <script src="https://unpkg.com/@ruffle-rs/ruffle"></script>
        </head>
        <body>
            <div id="flash-player"></div>
            <script>
                window.addEventListener("load", () => {
                    const ruffle = window.RufflePlayer.newest();
                    const player = ruffle.createPlayer();
                    const container = document.getElementById("flash-player");
                    container.appendChild(player);
                    player.load("http://localhost:8080/testing.swf");

                    // Optional: Adjust scaling based on SWF dimensions
                    player.addEventListener("load", () => {
                        const swfWidth = player.stage.width;
                        const swfHeight = player.stage.height;
                        const scaleX = container.clientWidth / swfWidth;
                        const scaleY = container.clientHeight / swfHeight;
                        const scale = Math.min(scaleX, scaleY);
                        player.style.transform = `scale(${scale})`;
                    });
                });
            </script>
        </body>
        </html>
        """
    }
}
