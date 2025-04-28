from flask import Flask, render_template, request
from pyswip import Prolog


app = Flask(__name__)
prolog = Prolog()
prolog.consult("logic.pl")



occasions = ["casual", "party", "formal", "work", "everyday"]
styles = ["vintage", "streetwear", "boho", "modern", "minimal", "sustainable"]
seasons = ["summer", "winter", "spring", "fall", "all_season"]

@app.route("/", methods=["GET", "POST"])
def index():
    recommendations = []
    selected = {"style": "", "occasion": "", "season": ""}

    if request.method == "POST":
        selected["style"] = request.form["style"]
        selected["occasion"] = request.form["occasion"]
        selected["season"] = request.form["season"]

        query = f"infer_outfit_by_input('{selected['style']}', '{selected['occasion']}', '{selected['season']}', List)"
        try:
            results = list(prolog.query(query, maxresult=1))
            if results:
                outfits = results[0]["List"]
                recommendations = outfits if isinstance(outfits, list) else [outfits]
        except Exception as e:
            recommendations = [f"⚠️ Error: {e}"]

    return render_template("index.html", styles=styles, occasions=occasions, seasons=seasons, selected=selected, recommendations=recommendations)

if __name__ == "__main__":
    app.run(debug=True)
