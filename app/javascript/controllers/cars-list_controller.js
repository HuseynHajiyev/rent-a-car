import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["map-button", "grid-button", "mapmap", "grid"]

  connect() {
    console.log("Hello!")
  }

  displayGrid() {
    this.gridTarget.classList.toggle("d-none")
    this.mapmapTarget.classList.toggle("d-none")
  }

  displayMap() {
    this.mapmapTarget.classList.toggle("d-none")
    this.gridTarget.classList.toggle("d-none")
  }
}
