import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["map-button", "gridButton", "mapmap", "grid"]

  connect() {
    console.log("Hello!")
  }

  displayToggle() {
    if (this.gridButtonTarget.innerText == "See all cars") {
      this.gridButtonTarget.innerText = "See cars on map"
    } else {
      this.gridButtonTarget.innerText = "See all cars"
    }
    this.gridTarget.classList.toggle("d-none")
    this.mapmapTarget.classList.toggle("d-none")
  }
}
