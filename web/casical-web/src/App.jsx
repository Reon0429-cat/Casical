import "../css/layout.css";

export const App = () => {
    return (
        <> < div id = "container" > <main>
            <div className="full-page">
                <div className="info">
                    <div className="upper">
                        <div className="github">
                            <ul className="github-top">
                                <li className="github-title info-title">GitHub</li>
                                <li className="github-followers">23
                                    <span>Followers</span>
                                </li>
                            </ul>
                            <div className="github-subtitle info-subtitle">
                                <p>Contributions</p>
                                <hr/></div>
                        </div>
                    </div>
                    <div className="lower">
                        <div className="message">
                            <img src="img/message-icon.png" alt=""/>
                            <p>Send Message</p>
                        </div>
                        <div className="qiita">
                            <ul className="qiita-top">
                                <li className="qiita-title info-title">Qiita</li>
                                <li className="qiita-contributions">5095
                                    <span>Contributions</span>
                                </li>
                                <li className="qiita-followers">123
                                    <span>Followers</span>
                                </li>
                            </ul>
                            <div className="qiita-subtitile info-subtitle">
                                <p>Tags</p>
                                <hr/></div>
                        </div>
                    </div>
                </div>
                <div className="about">
                    <div className="profile">
                        <div className="profile-top">
                            <img src="img/profile.png" alt=""/>
                            <div className="profile-content">
                                <p className="profile-name">OONISHI REON</p>
                                <ul className="profile-item">
                                    <li>●1年</li>
                                    <li>●東京</li>
                                </ul>
                            </div>
                        </div>
                        <div className="profile-id">
                            <p className="github-id">GitHub：Reon0429-cat</p>
                            <p className="qiita-id">Qiita：REON</p>
                        </div>
                        <div className="profile-bio">
                            <p>テキストテキストテキストテキストテキストテキストテキストテキスト</p>
                        </div>
                    </div>
                    <div className="skillscore">
                        <p className="about-title">Skill Score</p>
                        <div className="chart-area">
                            <canvas id="skillscore-chart"></canvas>
                        </div>
                    </div>
                    <div className="language">
                        <p className="about-title">Language
                            <span>from GitHub</span>
                        </p>
                        <div className="chart-area pie">
                            <canvas id="language-chart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</>
    );
}